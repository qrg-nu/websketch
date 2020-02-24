# Roles:

resource "aws_iam_role" "websketch-ec2-worker-nodes" {
  name = "${var.cluster-name}-ec2-worker-nodes"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "websketch-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.websketch-ec2-worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "websketch-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.websketch-ec2-worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "websketch-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.websketch-ec2-worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "websketch-AmazonEBS_CSI-driver" {
  policy_arn = aws_iam_policy.ebs-csi-driver.arn
  role = aws_iam_role.websketch-ec2-worker-nodes.name
}



# General EC2 Node Group
#
# The basic Kubernetes resources needed run here.
#

resource "aws_eks_node_group" "general" {
  cluster_name = aws_eks_cluster.websketch.name
  node_group_name = "general"
  node_role_arn = aws_iam_role.websketch-ec2-worker-nodes.arn
  subnet_ids = concat(aws_subnet.websketch-public[*].id, 
                      aws_subnet.websketch-private[*].id)
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  ami_type = "AL2_x86_64"
  disk_size = 10
  instance_types = ["t3.medium"]
  labels = {
    "nodeType" = "EC2"
    "role" = "general-kubernetes"
    "nodeSpecialization" = "none"
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS 
  # Node Group handling.  Otherwise, EKS will not be able to properly delete 
  # EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.websketch-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.websketch-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.websketch-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.websketch-AmazonEBS_CSI-driver
  ]
}



# WebSketch EC2 Node Group
#
# The WebSketch pods that require storage run here
#

resource "aws_eks_node_group" "websketch" {
  cluster_name = aws_eks_cluster.websketch.name
  node_group_name = "websketch"
  node_role_arn = aws_iam_role.websketch-ec2-worker-nodes.arn
  subnet_ids = [aws_subnet.websketch-private[0].id, aws_subnet.websketch-public[0].id]
                      
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  ami_type = "AL2_x86_64"
  disk_size = 10
  instance_types = ["t3.medium"]
  labels = {
    "nodeType" = "EC2"
    "role" = "websketch"
    "nodeSpecialization" = "websketch"
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS 
  # Node Group handling.  Otherwise, EKS will not be able to properly delete 
  # EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.websketch-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.websketch-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.websketch-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.websketch-AmazonEBS_CSI-driver
  ]
}
