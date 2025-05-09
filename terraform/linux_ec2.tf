resource "aws_instance" "linux_test" {
  instance_type               = "t3.micro"
  ami                         = data.aws_ami.amzn_linux_2023_latest.id
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  security_groups             = [aws_security_group.linux_test_sg.id]
  key_name                    = data.aws_key_pair.common.key_name
  tags = {
    usage : "test"
  }
}

resource "aws_security_group" "linux_test_sg" {
  name        = "linux_test_sg"
  description = "Security Group for Linux test server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amzn_linux_2023_latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}