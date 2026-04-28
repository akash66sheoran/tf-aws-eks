terraform {
  backend "s3" {
    bucket       = "stage-terraform-tfstate-storez"
    key          = "eks/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}