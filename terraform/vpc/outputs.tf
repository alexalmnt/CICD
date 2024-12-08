output "vpcid" {
  value = aws_vpc.vpc1.id
}
output "subnet1id" {
  value = aws_subnet.publicsub1.id
}
output "subnet2id" {
  value = aws_subnet.publicsub2.id
}