#!make

SHELL=/bin/bash

package: lambda.zip

lambda.zip: lambda.py rsa.py
	mkdir -p target
	cp *.py target
	pip install --upgrade -r requirements.txt --target target
	(cd target; zip ../lambda.zip -r .)
