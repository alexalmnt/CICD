terraform {
  backend "s3" {
    bucket = "gh-monte-state"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}