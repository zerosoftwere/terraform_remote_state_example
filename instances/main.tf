resource "aws_security_group" "main" {
  name   = "main-sg"
  vpc_id = data.terraform_remote_state.main.outputs.vpc_id

  dynamic "ingress" {
    for_each = [22, 80]
    iterator = port
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Main SG"
    Environment = terraform.workspace
  }
}

resource "aws_instance" "main" {
  ami                    = "ami-0840becec4971bb87"
  instance_type          = "t4g.nano"
  subnet_id              = data.terraform_remote_state.main.outputs.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "default"

  user_data = <<EOF
yum install httpd -y

systemctl enable httpd
systemctl start httpd

echo 'Hello World from Terraform Remote State' > /var/www/html/index.html
EOF

  tags = {
    Name = "Main Instance"
    Environment = upper(terraform.workspace)
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "public_ip" {
  value = aws_instance.main.public_ip
}
