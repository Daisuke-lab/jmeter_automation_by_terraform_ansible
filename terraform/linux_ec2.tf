resource "aws_instance" "windows_test" {
  instance_type = "t3.micro"
  ami = data.aws_ami.windows.id
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  security_groups = [aws_security_group.windows_test_sg.id]

  tags = {
    usage: "test"
  }
}

resource "aws_security_group" "windows_test_sg" {
  name        = "windows_test_sg"
  description = "Security Group for Windows test server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3389
    to_port     = 3389
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

data "aws_ami" "windows" {
     most_recent = true     
      filter {
            name   = "name"
            values = ["Windows_Server-2019-English-Full-Base-*"]  
        }     
      filter {
            name   = "virtualization-type"
            values = ["hvm"]  
        }     
      owners = ["801119661308"] # Canonical
}