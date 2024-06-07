# To Create Infra
resource "aws_instance" "web_app" {
  ami           = "ami-0705384c0b33c194c"
  instance_type = "t3.micro"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y apache2
              echo "<html><h1>Hello, World</h1></html>" > /var/www/html/index.html
              sudo systemctl start apache2
              sudo systemctl enable apache2
              EOF

  tags = {
    Name = "web-app-machine"
  }
  
  vpc_security_group_ids = [aws_security_group.web_app.id,]
}

resource "aws_security_group" "web_app" {
  name = "web-app-instance"
  
  tags = {
    Name = "web-app-security-group"
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

