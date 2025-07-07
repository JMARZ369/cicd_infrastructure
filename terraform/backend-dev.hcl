# backend-dev.tf
terraform {
  backend "s3" {
    bucket         = "dev-tf-state-cicd"
    key            = "vpc-dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-lock-dev"
  }
}
