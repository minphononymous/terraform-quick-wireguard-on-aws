provider "aws" {
  region = var.region


  default_tags {
    tags = {
      hashicorp-learn = "wireguard"
    }
  }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "kp" {
  key_name   = "wireguard_key"     
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.kp.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
}


resource "aws_instance" "wiregurad" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.instance_sg.name]
  associate_public_ip_address = true
  key_name      = aws_key_pair.kp.key_name
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
