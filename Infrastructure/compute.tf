resource "aws_iam_instance_profile" "runner_instance_profile" {
  name = "runner-instance-profile"
  role = aws_iam_role.github_actions_assume_role.name
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "template_file" "runner-userdata" {
  template = file("runner-userdata.sh")
}

data "template_cloudinit_config" "runner-userdata" {

  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.runner-userdata.rendered
  }

}

resource "aws_instance" "gh-runner" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.runner_instance_type
  key_name             = var.private_key
  iam_instance_profile = aws_iam_instance_profile.runner_instance_profile.name
  user_data            = data.template_cloudinit_config.runner-userdata.rendered

  tags = {
    Name = "GH Self-hosted Runner"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
  }
}

resource "aws_security_group" "gh-runner-sg" {
  vpc_id      = aws_vpc.runner-vpc.id
  name        = "gh-runner-sg"
  description = "security group for self-hosted runner ec2"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.my_ip_addr]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "gh-runner_arn" {
  value = aws_instance.gh-runner.arn
}