locals {
  
  private_sub_id = "${aws_subnet.private.*.id}"
  }
resource "aws_subnet" "private" {
  count = "${length(slice(local.az_names, 0, 2))}"
  vpc_id     = "${aws_vpc.my_app.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_names))}"
  availability_zone = "${local.az_names[count.index]}"

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}
resource "aws_instance" "nat" {
  
  ami                    = "${var.nat_amis[var.region]}"
  instance_type          = "t2.micro"
  subnet_id              = "${local.private_sub_id[0]}"
 vpc_security_group_ids = ["${aws_security_group.priv_sg.id}"]
  key_name               = "sivaTask"
  tags = {
    Name = "sivaNat"
  }
}
resource "aws_route_table" "privatert" {
  vpc_id = "${aws_vpc.my_app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags = {
    Name = "sivaprivatert"
  }
}
resource "aws_route_table_association" "private_sub_association" {
  
  subnet_id      = "${local.private_sub_id[0]}"
  route_table_id = "${aws_route_table.privatert.id}"
}

