module "vpc" {
  source    = "./vpc"
  vpcidr    = "10.0.0.0/16"
  vpcname   = "eks-vpc"
  pub1cidr  = "10.0.1.0/24"
  subnet1az = "us-east-1a"
  pub2cidr  = "10.0.2.0/24"
  subnet2az = "us-east-1b"
  sgname    = "ekssg"
  sgcidr    = "0.0.0.0/0"
}
module "eks" {
  source               = "./eks"
  eksclustername       = "tfekscluster"
  eksnodegroupname     = "fnodegroup"
  subnet1id            = module.vpc.subnet1id
  subnet2id            = module.vpc.subnet2id
  eksclusterrolename   = "eksnodegroup1"
  eksnodegrouprolename = "tfeksnodegroup"
  depends_on           = [module.vpc]

}