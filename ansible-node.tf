resource "aws_instance" "myec2-1" {
  ami                    = "ami-0ff30663ed13c2290"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykey.id
  vpc_security_group_ids = [aws_security_group.ssh-allow.id]
  tags = {
    OS = "amazon"
  }
}