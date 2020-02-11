resource "aws_key_pair" "test" {
  key_name   = "manual-testing"
  public_key = file(pathexpand(var.ssh_key))
}
