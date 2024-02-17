provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = var.S3_ENDPOINT
  }
}

resource "aws_s3_bucket" "ts_bucket" {
  bucket = "ts-bucket"

  depends_on = [helm_release.localstack]
}
