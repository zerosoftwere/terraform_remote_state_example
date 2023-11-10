data "terraform_remote_state" "main" {
  backend   = "s3"
  
  config = {
    region = "us-east-1"
    bucket = "<terraform state bucket>"
    key    = "vpc/terraform.tfstate"
  }
}
