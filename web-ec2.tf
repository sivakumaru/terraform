resource "aws_instance" "web" {
  count                  = "${var.web_ec2_count}"
  ami                    = "${var.web_amis[var.region]}"
  instance_type          = "${var.web_instance_type}"
 
  subnet_id              = "${local.pub_sub_id[count.index]}"
  key_name               = "sivaTask"
}