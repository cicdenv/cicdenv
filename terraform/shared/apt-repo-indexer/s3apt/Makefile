#!make

SHELL=/bin/bash

venv=.venv

zip_file=$(CURDIR)/s3apt.zip

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=apt-repo-$(domain)

venv:
	python -m venv $(venv)
	source $(venv)/bin/activate;     \
	pip install --upgrade pip;       \
	pip install -r requirements.txt

test:
	source $(venv)/bin/activate; python s3apt.py *.deb

upload:
	for deb in *.deb; do \
	    aws --profile=admin-main --region=us-west-2 s3 cp "$$deb" "s3://$(s3_bucket)/repo/dists/$${deb}"; \
	done

s3apt.zip: s3apt.py
	zip $(zip_file) s3apt.py 
	(cd $(venv)/lib/python*/site-packages/ ; zip -r $(zip_file) *)

package: s3apt.zip

publish: package
	aws --profile=admin-main --region=us-west-2 s3 cp $(zip_file) "s3://$(s3_bucket)/s3apt.zip"
