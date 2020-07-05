resource "aws_key_pair" "shared" {
  key_name   = "shared"
  public_key = file(pathexpand("~/.ssh/kops_rsa.pub"))
}
