resource "aws_security_group" "priv_sg" {
  name        = "web_sg"
  description = "Allow traffic for web apps on ec2"
  vpc_id      = "${aws_vpc.my_app.id}"
   ingress {
    from_port   = 1433
    to_port     = 1433
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