resource "aws_iam_role" "tfeksclusterrole" {
    name = var.eksclusterrolename
    assume_role_policy = jsonencode({
   "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
      },
    ]
  })

  
}
resource "aws_iam_role_policy_attachment" "ekspolicy1" {
    role = aws_iam_role.tfeksclusterrole.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "tfeksnodegrouprole" {
  name = var.eksnodegrouprolename
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "tfpolicyattach2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.tfeksnodegrouprole.name
}
resource "aws_iam_role_policy_attachment" "tfpolicyattach3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.tfeksnodegrouprole.name
}
resource "aws_iam_role_policy_attachment" "tfpolicyattach4" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.tfeksnodegrouprole.name
}
resource "aws_eks_cluster" "tfekscluster" {
  name     = var.eksclustername
  role_arn = aws_iam_role.tfeksclusterrole.arn

  vpc_config {
    subnet_ids = [
        var.subnet1id,
        var.subnet2id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [aws_iam_role_policy_attachment.ekspolicy1]
}

resource "aws_eks_node_group" "tfeksnodegroup" {
  cluster_name    = aws_eks_cluster.tfekscluster.name
  node_group_name = var.eksnodegroupname
  node_role_arn   = aws_iam_role.tfeksnodegrouprole.arn
  subnet_ids      = [
    var.subnet1id,
    var.subnet2id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

 depends_on = [
    aws_iam_role_policy_attachment.tfpolicyattach2,
    aws_iam_role_policy_attachment.tfpolicyattach3,
    aws_iam_role_policy_attachment.tfpolicyattach4
 ]
}
