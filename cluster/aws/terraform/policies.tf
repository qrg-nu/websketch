resource "aws_iam_policy" "ebs-csi-driver" {
  name = "${var.cluster-name}-ebs-csi-driver-policy"
  description = "Allows the Elastic Block Storage CSI Driver to access resources."
  policy = <<EBS_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EBS_POLICY
}

data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com", 
                     "eks.amazonaws.com", 
                     "eks-fargate-pods.amazonaws.com"
                    ]
    }
  }
}