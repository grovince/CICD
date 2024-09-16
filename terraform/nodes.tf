resource "aws_iam_role" "private-group-nodes" {
    name = var.private_group_nodes.name

    assume_role_policy = jsonencode({
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
        }]
        Version = "2012-10-17"
    })
}

resource "aws_iam_policy" "s3_access" {
  name        = "s3_access_for_eks"
  path        = "/"
  description = "IAM policy for accessing S3 from EKS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.s3_bucket.arn,
          "${aws_s3_bucket.s3_bucket.arn}/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "private-nodes-AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.private-group-nodes.name
}

resource "aws_iam_role_policy_attachment" "private-nodes-AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.private-group-nodes.name
}

resource "aws_iam_role_policy_attachment" "private-nodes-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.private-group-nodes.name
}

### s3 iam policy attachment 
resource "aws_iam_role_policy_attachment" "private-nodes-s3-access" {
    policy_arn = aws_iam_policy.s3_access.arn
    role       = aws_iam_role.private-group-nodes.name
}


resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.private_group_nodes.name
  node_role_arn   = aws_iam_role.private-group-nodes.arn

  subnet_ids = [
    aws_subnet.private-subnet.id
  ]
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "PrivateNode"
  }

  depends_on = [
    aws_iam_role_policy_attachment.private-nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.private-nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.private-nodes-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.private-nodes-s3-access
  ]
}





### public node 

resource "aws_iam_role" "public-group-nodes" {
    name = var.public_group_nodes.name

    assume_role_policy = jsonencode({
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
        }]
        Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachment" "public-nodes-AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.public-group-nodes.name
}

resource "aws_iam_role_policy_attachment" "public-nodes-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.public-group-nodes.name
}


resource "aws_eks_node_group" "public-nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.public_group_nodes.name
  node_role_arn   = aws_iam_role.public-group-nodes.arn

  subnet_ids = [
    aws_subnet.public-subnet.id
  ]
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "PublicNode"
  }

  depends_on = [
    aws_iam_role_policy_attachment.public-nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.public-nodes-AmazonEC2ContainerRegistryReadOnly
  ]
}