resource "aws_security_group" "ekssg" {
  name        = var.sgname
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_vpc.vpc1.id

  tags = {
    Name = "eks security group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_tls_ipv4" {
  security_group_id = aws_security_group.ekssg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_tls_ipv6" {
  security_group_id = aws_security_group.ekssg.id
  cidr_ipv4        = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_https_tls_ipv4" {
  security_group_id = aws_security_group.ekssg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ekssg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
