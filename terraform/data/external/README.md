## Purpose
These [terraform external datasources](https://www.terraform.io/docs/providers/external/data_source.html) replace local files
with lookup scripts.

## Usage
### Terraform
```hcl
data "external" "vpc-endpoints" {
  program = ["${path.module}/.../data/external/dynamodb-scan-for-attribute.py"]

  query = {
    dynamodb_table = "kops-clusters"
    attribute      = "FQDN"
  }
}
```

### Command Line
* dynamodb-scan-for-attribute.py
  ```
  echo '{
  	"dynamodb_table": "kops-clusters", 
  	"attribute": "FQDN"
  }' \
  | "AWS_PROFILE=admin-main" "AWS_DEFAULT_REGION=us-west-2" \
    "terraform/data/external/dynamodb-scan-for-attribute.py"
  {"items": "<fqdn1>,<fqdn2>,..."}
  ```
