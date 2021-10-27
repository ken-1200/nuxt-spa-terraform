provider "aws" {
  profile = "${var.aws_profile}"
  region = "ap-northeast-1"
}

provider "aws" {
  profile = "${var.aws_profile}"
  alias  = "northern-virginia"
  region = "us-east-1"
}