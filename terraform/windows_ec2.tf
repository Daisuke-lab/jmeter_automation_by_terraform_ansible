resource "aws_instance" "linux_test" {
  instance_type = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  security_groups = [aws_security_group.linux_test_sg.id]
  tags = {
    usage: "test"
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