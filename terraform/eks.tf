resource "aws_iam_role" "cluster" {
    name = "eks-role-clsuter"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}  

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster.name
  role_arn = aws_iam_role.clsuter.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-subnet.id,
      aws_subnet.public-subnet.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.clsuter-AmazonEKSClusterPolicy]
}