resource "aws_vpc" "runner-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.runner-vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "runner-gw" {
  vpc_id = "${aws_vpc.runner-vpc.id}"
}

resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.runner-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.runner-gw.id}"
  }
}

resource "aws_route_table_association" "public-route-1-a" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}