#!/bin/bash

set -eu -o pipefail

# Packages needed:
# * zbar-tools
# * oathtool

# Usage
# $0 <iam-user> <keybase-user>

PROFILE=admin-main

IAM_USER=${1?Usage: $0 <iam-user> <keybase-user>}
KEYBASE_USER=${2?Usage: $0 <iam-user> <keybase-user>}

qrcode_file=~/.aws/${IAM_USER}-QRCode.png
secret_file=~/.aws/${IAM_USER}-secret.txt

# Set current directory to the project root folder
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
pushd "$DIR/../../../.." >/dev/null

bin/cicdctl creds aws-mfa main

qrcode_encrypted="mfa-virtual-devices/${IAM_USER}-QRCode.png"
secret_encrypted="mfa-virtual-devices/${IAM_USER}-secret.txt"

sleep_interval=31

# If this iam user already has a virtual MFA device enabled,
# we get its serial here
echo "User: $IAM_USER, checking for attached virtual MFA device..."
mfa_serial=$(\
aws --profile=${PROFILE} \
    iam list-mfa-devices \
    --user-name "$IAM_USER" \
| jq -r '.MFADevices[].SerialNumber' \
)

if [[ -z ${mfa_serial// /} ]]; then
	echo "User: $IAM_USER, does not have an attached virtual MFA device."

    # A virtual MFA device might already exist, if so remove it
    # {
    #     "VirtualMFADevices": [
    #         {
    #             "SerialNumber": "arn:aws:iam::014719181291:mfa/users/fvogt/fvogtMFADevice"
    #         },
    #         ...
    #     ]
    # }
    echo "User: $IAM_USER, checking for un-attached virtual MFA device..."
    mfa_serial=$(\
    aws --profile=${PROFILE} \
        iam list-virtual-mfa-devices \
        | jq -r '.VirtualMFADevices[].SerialNumber' | grep "/users/${IAM_USER}/${IAM_USER}MFADevice" \
    )
    if [[ ! -z ${mfa_serial// /} ]]; then
	    echo "User: $IAM_USER, deleting un-attached virtual MFA device, mfa-serial: $mfa_serial"
	    aws --profile=${PROFILE} \
            iam delete-virtual-mfa-device \
            --serial-number "$mfa_serial"
    fi

    # Create an un-attached virtual MFA device
    # {
    #     "VirtualMFADevice": {
    #         "SerialNumber": "arn:aws:iam::014719181291:mfa/users/fvogt/fvogtMFADevice"
    #     }
    # }
    echo "User: $IAM_USER, creating un-attached virtual MFA device..."
    mfa_serial=$(\
    aws --profile=${PROFILE} \
        iam create-virtual-mfa-device \
        --path /users/${IAM_USER}/ \
        --virtual-mfa-device-name ${IAM_USER}MFADevice \
        --outfile "$qrcode_file" \
        --bootstrap-method QRCodePNG \
    | jq -r '.VirtualMFADevice.SerialNumber' \
    )
    echo "User: $IAM_USER, created virtual MFA device, mfa-serial: $mfa_serial"

    # Extract MFA secret value from QRCode
    zbarimg -q "$qrcode_file" | sed -E 's/.*secret=([A-Z0-9]+).*/\1/' > "$secret_file"
    
    # Get 2 consecutive One Time Passwords from MFA secret
    echo "User: $IAM_USER, getting consecutive time based one time passwords..."
    otp1=$(oathtool --base32 --totp $(cat "$secret_file"))
    sleep $sleep_interval
    otp2=$(oathtool --base32 --totp $(cat "$secret_file"))
    
    # Attach the virtual device MFA device to the IAM user
    echo "User: $IAM_USER, associating virtual MFA device..."
    aws --profile=${PROFILE} \
        iam enable-mfa-device \
        --user-name "$IAM_USER" \
        --serial-number "$mfa_serial" \
        --authentication-code1 "$otp1" \
        --authentication-code2 "$otp2"

    # Encrypt, save mfa seed files
    mkdir -p "mfa-virtual-devices"
    echo "User: $IAM_USER, saving MFA seed files..."
    keybase encrypt --infile "$qrcode_file" --outfile "${qrcode_encrypted}.gpg" "$KEYBASE_USER"
    keybase encrypt --infile "$secret_file" --outfile "${secret_encrypted}.gpg" "$KEYBASE_USER"

    # Lame, delay here so final test using the next one time password value
    echo "User: $IAM_USER, waiting for next time based one time password..."
    sleep $sleep_interval

else
    echo "User: $IAM_USER, mfa-serial: $mfa_serial"
fi

popd >/dev/null
