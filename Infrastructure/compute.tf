resource "aws_instance" "gh-runner" {
  ami                         = var.ami_id
  instance_type               = var.runner_instance_type
  root_block_device           {
      volume_type = "gp3"
      volume_size = 8
      delete_on_termination = true
    }
}

resource "aws_security_group" "gh-runner-sg" {
  vpc_id = "${aws_vpc.runner-vpc.id}"
  name = "gh-runner-sg"
  description = "security group for self-hosted runner ec2"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip_addr]
  }
}