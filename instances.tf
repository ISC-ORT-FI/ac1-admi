resource "aws_instance" "ac1-instance" {
  ami                    = "ami-03ededff12e34e59e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.ac1-private-subnet.id
  vpc_security_group_ids = [aws_security_group.ac1-sg.id]
  key_name               = "act_clase"
  tags = {
    Name      = "ac1-instance"
    terraform = "True"

  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("act_clase.pem")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd git curl",
      "git clone https://github.com/mauricioamendola/chaos-monkey-app.git",
      "sudo mv chaos-monkey-app/website/* /var/www/html/",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
    ]
  }
}
