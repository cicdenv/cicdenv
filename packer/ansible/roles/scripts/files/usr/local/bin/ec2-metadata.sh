#!/bin/bash
#
#########################################################################
#This software code is made available "AS IS" without warranties of any #
#kind. You may copy, display, modify and redistribute the software      #
#code either by itself or as incorporated into your code; provided that #
#you do not remove any proprietary notices. Your use of this software   #
#code is at your own risk and you waive any claim against Amazon        #
#Digital Services, Inc. or its affiliates with respect to your use of   #
#this software code. (c) 2006-2007 Amazon Digital Services, Inc. or its #
#affiliates.                                                            #
#########################################################################

function print_help() {
echo "modified ec2-metadata v0.1.1 - https://s3.console.aws.amazon.com/s3/buckets/ec2metadata
Use to retrieve EC2 instance metadata from within a running EC2 instance. 
e.g. to retrieve instance id: ec2-metadata -i
         to retrieve ami id: ec2-metadata -a
         to get help: ec2-metadata --help
For more information on Amazon EC2 instance meta-data, refer to the documentation at
http://docs.amazonwebservices.com/AWSEC2/2008-05-05/DeveloperGuide/AESDG-chapter-instancedata.html

Usage: ec2-metadata <option>
Options:
--all                     Show all metadata information for this host (also default).
-a/--ami-id               The AMI ID used to launch this instance
-l/--ami-launch-index     The index of this instance in the reservation (per AMI).
-m/--ami-manifest-path    The manifest path of the AMI with which the instance was launched.
-n/--ancestor-ami-ids     The AMI IDs of any instances that were rebundled to create this AMI.
-b/--block-device-mapping Defines native device names to use when exposing virtual devices.
-i/--instance-id          The ID of this instance
-t/--instance-type        The type of instance to launch. For more information, see Instance Types.
-h/--local-hostname       The local hostname of the instance.
-o/--local-ipv4           Public IP address if launched with direct addressing; private IP address if launched with public addressing.
-k/--kernel-id            The ID of the kernel launched with this instance, if applicable.
-z/--availability-zone    The availability zone in which the instance launched. Same as placement
-c/--product-codes        Product codes associated with this instance.
-p/--public-hostname      The public hostname of the instance.
-v/--public-ipv4          NATted public IP Address
-u/--public-keys          Public keys. Only available if supplied at instance launch time
-r/--ramdisk-id           The ID of the RAM disk launched with this instance, if applicable.
-e/--reservation-id       ID of the reservation.
-s/--security-groups      Names of the security groups the instance is launched in. Only available if supplied at instance launch time
-d/--user-data            User-supplied data.Only available if supplied at instance launch time."
}

#check some basic configurations before running the code
function chk_config() {
    #check if run inside an ec2-instance
    x=$(curl -s http://169.254.169.254/)
    if [ $? -gt 0 ]; then
        echo '[ERROR] Command not valid outside EC2 instance. Please run this command within a running EC2 instance.'
        exit 1
    fi
}

#get an http session token - IMDSv2 only
function session_token() {
    if curl -s http://169.254.169.254/latest/api/token; then
        export IMDSv2_TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 30" -sL "http://169.254.169.254/latest/api/token")
        export IMDSv2_HEADER="-H X-aws-ec2-metadata-token:${IMDSv2_TOKEN}"
    else
        export IMDSv2_TOKEN=
        export IMDSv2_HEADER=
    fi
}

#print standard value
function print_value() {
    RESPONSE=$(curl -fs $IMDSv2_HEADER http://169.254.169.254/latest/meta-data/${1}/)
    if [ $? == 0 ]; then
        echo $RESPONSE
    else
        echo not available
    fi
}

#print value that might be gzipped, base64 encoded
function print_userdata() {
    maybe_gzipped=$(mktemp /tmp/ec2-metadata-userdata.XXXX)
    trap "{ rm -f '$maybe_gzipped'; }" EXIT
    curl -fs $IMDSv2_HEADER http://169.254.169.254/latest/user-data/ > "$maybe_gzipped"
    if [ $? == 0 ]; then
        ## GZipped ?
        if (file "$maybe_gzipped" | grep -q 'compressed') ; then
            maybe_base64=$(mktemp /tmp/ec2-metadata-userdata.XXXX)
            trap "{ rm -f '$maybe_gzipped' '$maybe_base64'; }" EXIT
            gzip --decompress < "$maybe_gzipped" > "$maybe_base64"
            ## base64 encoded ?
            if base64 --decode "$maybe_base64" &> /dev/null; then
                base64 --decode "$maybe_base64"
            else
                cat "$maybe_base64"
            fi
        else
            cat < "$tmp_file1"
        fi
    else
        echo not available
    fi
}

#print block-device-mapping
function print_block-device-mapping() {
    x=$(curl -fs $IMDSv2_HEADER http://169.254.169.254/latest/meta-data/block-device-mapping/)
    if [ $? -eq 0 ]; then
        for i in $x; do
            echo -e '\t' $i: $(curl -s http://169.254.169.254/latest/meta-data/block-device-mapping/$i)
        done
    else
        echo not available
    fi
}

#print public-keys
function print_public-keys() {
    x=$(curl -fs $IMDSv2_HEADER http://169.254.169.254/latest/meta-data/public-keys/)
    if [ $? -eq 0 ]; then
        for i in $x; do
            index=$(echo $i|cut -d = -f 1)
            keyname=$(echo $i|cut -d = -f 2)
            echo keyname:$keyname
            echo index:$index
            format=$(curl -s $IMDSv2_HEADER http://169.254.169.254/latest/meta-data/public-keys/$index/)
            echo format:$format
            echo 'key:(begins from next line)'
            echo $(curl -s $IMDSv2_HEADER http://169.254.169.254/latest/meta-data/public-keys/$index/$format)
        done
    else
        echo not available
    fi
}

function print_with_header() {
    echo -n "$1: "
    print_value "$1"
}

function print_all() {
    print_with_header ami-id
    print_with_header ami-launch-index
    print_with_header ami-manifest-path
    print_with_header ancestor-ami-ids

    echo 'block-device-mapping: '
    print_block-device-mapping
    
    print_with_header instance-id
    print_with_header instance-type
    print_with_header local-hostname
    print_with_header local-ipv4
    print_with_header kernel-id
    print_with_header placement/availability-zone
    print_with_header product-codes
    print_with_header public-hostname
    print_with_header public-ipv4
    
    echo 'public-keys: '
    print_public-keys

    print_with_header ramdisk-id
    print_with_header reservation-id
    print_with_header security-groups

    echo 'user-data: '
    print_userdata
}

#check if run inside an EC2 instance
chk_config
session_token

#command called in default mode
if [ "$#" -eq 0 ]; then
    print_all
fi

#start processing command line arguments
while [ "$1" != "" ]; do
    case $1 in
    -a | --ami-id )                print_value ami-id meta-data/ami-id
                                                                 ;;
    -l | --ami-launch-index )      print_value ami-launch-index meta-data/ami-launch-index
                                                                 ;;
    -m | --ami-manifest-path )     print_value ami-manifest-path meta-data/ami-manifest-path
                                                                 ;;
    -n | --ancestor-ami-ids )      print_value ancestor-ami-ids meta-data/ancestor-ami-ids
                                                                 ;;
    -b | --block-device-mapping )  print_block-device-mapping
                                                                 ;;
    -i | --instance-id )           print_value instance-id meta-data/instance-id
                                                                 ;;
    -t | --instance-type )         print_value instance-type meta-data/instance-type
                                                                 ;;
    -h | --local-hostname )        print_value local-hostname meta-data/local-hostname
                                                                 ;;
    -o | --local-ipv4 )            print_value local-ipv4 meta-data/local-ipv4
                                                                 ;;
    -k | --kernel-id )             print_value kernel-id meta-data/kernel-id
                                                                 ;;
    -z | --availability-zone )     print_value placement/availability-zone meta-data/placement/availability-zone
                                                                 ;;
    -c | --product-codes )         print_value product-codes meta-data/product-codes
                                                                 ;;
    -p | --public-hostname )       print_value public-hostname meta-data/public-hostname
                                                                 ;;
    -v | --public-ipv4 )           print_value public-ipv4 meta-data/public-ipv4
                                                                 ;;
    -u | --public-keys )           print_public-keys
                                                                 ;;
    -r | --ramdisk-id )            print_value ramdisk-id /meta-data/ramdisk-id
                                                                 ;;
    -e | --reservation-id )        print_value reservation-id /meta-data/reservation-id
                                                                 ;;
    -s | --security-groups )       print_value security-groups meta-data/security-groups
                                                                 ;;
    -d | --user-data )             print_userdata
                                                                 ;;
    -h | --help )                  print_help
                                 exit
                                                                 ;;
    --all )                        print_all
                                 exit 
                                                                 ;;
    * )                            print_help
                                 exit 1
    esac
    shift
done
