data "local_file" "ssh_key" {
  filename = pathexpand(var.ssh_key)
}

resource "aws_key_pair" "test" {
  key_name   = "manual-testing"
  public_key = data.local_file.ssh_key.content
}
