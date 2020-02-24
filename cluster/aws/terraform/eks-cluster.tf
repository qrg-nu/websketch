resource "aws_iam_role" "websketch-cluster" {
  name = "${var.cluster-name}-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "websketch-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.websketch-cluster.name
}

resource "aws_iam_role_policy_attachment" "websketch-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.websketch-cluster.name
}

resource "aws_security_group" "websketch-cluster" {
  name        = "websketch-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.websketch.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "websketch-secgrp"
  }
}

# resource "aws_security_group_rule" "websketch-cluster-ingress-workstation-https" {
#   cidr_blocks       = [local.workstation-external-cidr]
#   description       = "Allow workstation to communicate with the cluster API Server"
#   from_port         = 443
#   protocol          = "tcp"
#   security_group_id = aws_security_group.websketch-cluster.id
#   to_port           = 443
#   type              = "ingress"
# }

resource "aws_eks_cluster" "websketch" {
  name = var.cluster-name
  role_arn = aws_iam_role.websketch-cluster.arn
  vpc_config {
    security_group_ids = [aws_security_group.websketch-cluster.id]
    subnet_ids = concat(aws_subnet.websketch-public[*].id, 
                        aws_subnet.websketch-private[*].id)
    public_access_cidrs = ["0.0.0.0/0"]
    endpoint_private_access = true
    endpoint_public_access = true
  }
  depends_on = [
    aws_iam_role_policy_attachment.websketch-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.websketch-AmazonEKSServicePolicy,
  ]
}