resource "aws_instance" "ubuntu_webserver" {
  ami                    = "${data.aws_ami.latest_ubuntu.id}"
  instance_type          = "t2.micro"
# VPC
  subnet_id              = "${aws_subnet.prod-subnet-public-1.id}"
# Security Group
  vpc_security_group_ids = ["${aws_security_group.allowed.id}"]
  key_name               = "frankfurt-eu-central-1-key2"

  user_data              = templatefile("user_data.sh.tpl",{
    version              = "version 2.1"
    })

    ebs_block_device {
      device_name = "/dev/sda1"
      volume_size = 10
      volume_type = "gp2"
    }

  tags = {
    Name = "app webserver"
  }
# start env before destroy old env
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"

  tags = {
    Name = "app webserver"
  }

}

resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "eu-central-1a"

    tags = {
      Name = "app webserver"
  }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}

resource "aws_internet_gateway" "prod-igw" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
}

resource "aws_route_table" "prod-public-crt" {
    vpc_id = "${aws_vpc.prod-vpc.id}"

    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.prod-igw.id}"
    }
}

resource "aws_security_group" "allowed" {
    name = "Dynamic Security Group"
    vpc_id = "${aws_vpc.prod-vpc.id}"

    tags = {
      Name = "app webserver"
      
    }

    dynamic "ingress" {
      for_each = ["22", "8080"]
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
}

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
      }
}
