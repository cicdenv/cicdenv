## Layers
Can't upgrade to `python 3.8` until we create a layer with gnupg installed.

* https://github.com/hanazuki/lambda-layer-gnupg
* https://github.com/lambci/yumda
* https://github.com/lambci/docker-lambda/tree/master/python3.8
* https://cloudbriefly.com/post/exploring-the-aws-lambda-execution-environment/
* https://medium.com/@jenoyamma/how-to-install-python-packages-for-aws-lambda-layer-74e193c76a91

```
python 3.8 + gpg 
  => /opt/bin
  => /var/task

yum install gnupg
```

```
Amazon Linux release 2 (Karoo)	4.14.138-99.102.amzn2.x86_64

PYTHONPATH
/var/runtime

PATH /var/lang/bin:/usr/local/bin:/usr/bin/:/bin:/opt/bin
LD_LIBRARY_PATH /var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib

LAMBDA_RUNTIME_DIR	/var/runtime
LAMBDA_TASK_ROOT	/var/task

gnupg2	2.0.28	2.33.amzn1	x86_64
```
