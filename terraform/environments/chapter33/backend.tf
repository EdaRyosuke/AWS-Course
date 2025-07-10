terraform {
  backend "s3" {
    bucket = "a1-mybucket"
    key    = "chapter33/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
