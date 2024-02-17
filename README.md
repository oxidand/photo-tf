# tf
 
Create `terraform.tfvars` or set variable through env:


```
AWS_ACCESS_KEY = "test"
AWS_SECRET_KEY = "test"
AWS_REGION     = "us-east-1"
S3_ENDPOINT    = "http://localhost:30007"
STACK_NAME     = "localstack"
KUBE_CONTEXT   = "rancher-desktop"
KUBE_CONFIG_PATH = "~/.kube/config"
```

1. `terraform init`
2. `terraform plan`
3. `terraform apply`
