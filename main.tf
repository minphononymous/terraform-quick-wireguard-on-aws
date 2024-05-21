provider "aws" {
  region = var.region

  default_tags {
    tags = {
      hashicorp-learn = "wireguard"
    }
  }
}

resource "aws_instance" "wiregurad" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.instance_sg.name]
  associate_public_ip_address = true
  key_name      = "temp-wind"
  user_data = file("userdata.sh")
  security_groups = [aws_security_group.instance_sg.name]
}

resource "aws_security_group" "instance_sg" {
  name        = "wireguard_sg"
  description = "Security group for instance to allow UDP/51820 inbound"

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
