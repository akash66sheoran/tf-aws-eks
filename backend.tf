terraform {
  backend "s3" {
    bucket = "terraform-tfstate-storez"
    key    = "tf-aws-eks.tfstate"
    region = "ap-south-1"
  }
}
