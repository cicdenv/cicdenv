#!make

SHELL=/bin/bash

package: lambda.zip layer.zip

target:

lambda.zip: lambda.py ca.py ca-config.json ca-csr.json
	mkdir -p target
	cp *.py conf/*.json target
	pip install --upgrade -r requirements.txt --target target
	(cd target; zip ../lambda.zip -r .)

layer.zip: 
	zip layer.zip /bin/{cfssl,cfssljson}
