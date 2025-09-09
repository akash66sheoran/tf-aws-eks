terraform {
  backend "s3" {
    bucket = "tfstate-storez"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
