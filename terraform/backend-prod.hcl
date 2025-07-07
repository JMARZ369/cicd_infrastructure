# backend-prod.tf
terraform {
  backend "s3" {
    bucket         = "prod-tf-state-cicd"
    key            = "vpc-prod/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-lock-prod"
  }
}
