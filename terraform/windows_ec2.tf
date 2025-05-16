resource "aws_instance" "windows_test" {
  instance_type               = "t3.micro"
  ami                         = data.aws_ami.windows.id
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  security_groups             = [aws_security_group.windows_test_sg.id]
  key_name                    = data.aws_key_pair.common.key_name
  user_data = <<EOF
  <powershell>
  # Create self signed certificate
  $certParams = @{
      CertStoreLocation = 'Cert:\LocalMachine\My'
      DnsName           = $env:COMPUTERNAME
      NotAfter          = (Get-Date).AddYears(1)
      Provider          = 'Microsoft Software Key Storage Provider'
      Subject           = "CN=$env:COMPUTERNAME"
  }
  $cert = New-SelfSignedCertificate @certParams

  # Create HTTPS listener
  $httpsParams = @{
      ResourceURI = 'winrm/config/listener'
      SelectorSet = @{
          Transport = "HTTPS"
          Address   = "*"
      }
      ValueSet = @{
          CertificateThumbprint = $cert.Thumbprint
          Enabled               = $true
      }
  }
  New-WSManInstance @httpsParams

  # Opens port 5986 for all profiles
  $firewallParams = @{
      Action      = 'Allow'
      Description = 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]'
      Direction   = 'Inbound'
      DisplayName = 'Windows Remote Management (HTTPS-In)'
      LocalPort   = 5986
      Profile     = 'Any'
      Protocol    = 'TCP'
  }
  New-NetFirewallRule @firewallParams
  </powershell>
  EOF
  get_password_data = true
  tags = {
    usage : "test"
    os: "windows"
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
  ingress {
    from_port   = 5986
    to_port     = 5986
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

output "windows_encrypted_password" {
  value = aws_instance.windows_test.password_data
}
output "windows_instance_id" {
  value = aws_instance.windows_test.id
}