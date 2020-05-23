#!make

SHELL=/bin/bash

package: lambda.zip

target:
	mkdir target

lambda.zip: target deps lambda.py
	cp lambda.py .python-version target
	(cd target; zip ../lambda.zip -r .)

deps: target
	pip install --upgrade -r requirements.txt --target target
