variable "project_name" {
  description = "Project Name"
}

variable "ssh_private_key" {
  description = "SSH Private Key File"
}

variable "ssh_public_key" {
  description = "SSH Public Key File"
}

variable "ssh_user" {
  default     = "core"
  description = "SSH User Name"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "default" {
  cidr_block = "${aws_vpc.default.cidr_block}"
  vpc_id     = "${aws_vpc.default.id}"
}

resource "aws_route" "default" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_security_group" "default" {
  name   = "${var.project_name}"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }
}

resource "aws_network_interface" "default" {
  security_groups = ["${aws_security_group.default.id}"]
  subnet_id       = "${aws_subnet.default.id}"
}

resource "aws_eip" "default" {
  network_interface = "${aws_network_interface.default.id}"
}

resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}"
  public_key = "${file("${var.ssh_public_key}")}"
}

resource "aws_instance" "default" {
  ami           = "ami-9c16adf8"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.default.key_name}"

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.default.id}"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 32
    volume_type           = "standard"
  }
}

#output "public_ip" {
#  value = "${aws_eip.default.public_ip}"
#}

output "ssh_private_key" {
  value = "${var.ssh_private_key}"
}

output "ssh_user" {
  value = "${var.ssh_user}"
}
