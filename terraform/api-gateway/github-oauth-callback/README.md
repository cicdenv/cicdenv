## Testing
* invoke commands
* output info

```
HTTP/1.1 302 Found
Content-Type: text/html
Content-Length: 503
Connection: keep-alive
Date: Fri, 08 Jul 2016 16:16:44 GMT
Location: http://www.amazon.com/
```

Makefile:
```make
venv:
	if [ ! -d "$(venv)" ]; then python -m venv $(venv); fi
	source $(venv)/bin/activate;     \
	pip install --upgrade pip;       \
	pip install -r requirements.txt

test: venv
	source $(venv)/bin/activate; python ...

lambda.zip: lambda.py venv
	zip $(zip_file) lambda.py 
	(cd $(venv)/lib/python*/site-packages/ ; zip -r $(zip_file) *)

package: lambda.zip
```

## Links
* https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-context.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-package.html
  * https://docs.aws.amazon.com/lambda/latest/dg/python-logging.html
* https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html
* https://aws.amazon.com/api-gateway/
* https://github.com/eagleDiego/apiGateway-lambdaProxy/blob/master/lambda_function.py
* https://aws.amazon.com/blogs/compute/redirection-in-a-serverless-api-with-aws-lambda-and-amazon-api-gateway/
* https://www.olicole.net/blog/2017/07/terraforming-aws-a-serverless-website-backend-part-3/

SDK:
* http://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

Other:
* https://github.com/DevinJeon/terraform-redirect
* https://github.com/markis/redirect-service
