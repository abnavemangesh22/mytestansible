resource "tls_private_key" "mytls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "mykey" {
  key_name   = "deployer-key"
  public_key = tls_private_key.mytls.public_key_openssh
}


output "mykey" {
  value     = tls_private_key.mytls.private_key_pem
  sensitive = true
}
