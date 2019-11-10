## Purpose
Simple scripts to create/enable virtual MFA devices.

## Background
https://thirld.com/blog/2016/01/16/generating-two-factor-authentication-codes-on-linux/

```
Base32StringSeed

QRCodePNG
otpauth://totp/$virtualMFADeviceName@$AccountName?secret=$Base32String
```

packages:
* zbar (zbar-tools - ubuntu)
* oathtool

```
zbarimg -q /tmp/QRCode.png 
QR-Code:otpauth://totp/Amazon%20Web%20Services:fvogtMFADevice@linux240b?secret=<SECRET>&issuer=Amazon%20Web%20Services

oathtool --base32 --totp $(zbarimg -q /tmp/QRCode.png | sed -E 's/.*secret=([A-Z0-9]+).*/\1/')
```

## AWS
```
aws iam
  *-mfa-device*
```

## setup-virtual-mfa-device.sh
Dettach mfa device (for rerunning the script):
```
aws --profile=admin-root \
    iam deactivate-mfa-device \
          --user-name fvogt \
          --serial-number "arn:aws:iam::014719181291:mfa/users/fvogt/fvogtMFADevice"
```
