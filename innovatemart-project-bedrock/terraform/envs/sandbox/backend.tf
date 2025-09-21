terraform {
  backend "s3" {
    bucket         = "innovatemart-terraform-state"
    key            = "sandbox/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}