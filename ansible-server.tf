
resource "aws_instance" "myec2" {
  ami                    = "ami-0ff30663ed13c2290"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykey.id
  vpc_security_group_ids = [aws_security_group.ssh-allow.id]
  tags = {
    env = "ansiblesrv"
  }
  user_data = file("install.sh")

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /tmp/myproject",
      "sudo chmod 775 -R /tmp/myproject"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      private_key = tls_private_key.mytls.private_key_pem
      password    = ""
      user        = "ec2-user"
    }
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    private_key = tls_private_key.mytls.private_key_pem
    password    = ""
    user        = "ec2-user"
  }

  provisioner "file" {
    source      = "aws_ec2.yaml"
    destination = "/tmp/aws_ec2.yaml"
  }

  provisioner "file" {
    source      = "ansible.conf"
    destination = "/tmp/ansible.conf"
  }

  provisioner "file" {
    source      = "mykey.pem"
    destination = "/tmp/mykey.pem"
  }

provisioner "remote-exec" {
  connection {
    type        = "ssh"
    host        = self.public_ip
    private_key = tls_private_key.mytls.private_key_pem
    password    = ""
    user        = "ec2-user"
  }
  inline = [ 
    "ansible -i /tmp/aws_ec2.yaml -m command -a 'hostname'"
   ]
}

}

resource "local_file" "cloud_pem" {
  filename = "./mykey.pem"
  content  = tls_private_key.mytls.private_key_pem
}


