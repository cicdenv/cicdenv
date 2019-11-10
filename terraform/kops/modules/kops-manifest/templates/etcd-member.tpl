    - instanceGroup: master-${availability_zone}
      name: ${element(split("", availability_zone), length(region))}
      encryptedVolume: true
      kmsKeyId: ${etcd_key_arn}