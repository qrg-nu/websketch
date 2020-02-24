# Roles:

resource "aws_iam_role" "websketch-fargate" {
  name = "${var.cluster-name}-fargate-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "websketch-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role = aws_iam_role.websketch-fargate.name
}


# WebSketch Fargate Profile:

resource "aws_eks_fargate_profile" "websketch" {
  fargate_profile_name = "websketch"
  cluster_name = aws_eks_cluster.websketch.name
  pod_execution_role_arn = aws_iam_role.websketch-fargate.arn
  subnet_ids = aws_subnet.websketch-private[*].id
  selector {
    namespace = "websketch"
    labels = {
      awsNodeType = "Fargate"
    }
  }
}


# Kubernetes Dashboard Fargate Profile:

resource "aws_eks_fargate_profile" "kub-dashboard" {
  fargate_profile_name = "kub-dashboard"
  cluster_name = aws_eks_cluster.websketch.name
  pod_execution_role_arn = aws_iam_role.websketch-fargate.arn
  subnet_ids = aws_subnet.websketch-private[*].id
  selector {
    namespace = "kubernetes-dashboard"
  }
}
