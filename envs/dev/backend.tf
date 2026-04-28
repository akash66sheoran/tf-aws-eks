terraform {
  backend "s3" {
    bucket       = "dev-terraform-tfstate-storez"
    key          = "eks/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}