locals {

# =============================================================================
  config_map_aws_auth = <<CONFIGMAPAWSAUTH

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.websketch-cluster.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

# =============================================================================
  kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.websketch.endpoint}
    certificate-authority-data: 
      ${aws_eks_cluster.websketch.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG

# =============================================================================
  volumes-overlay = <<VOL_OVERLAY

apiVersion: v1
kind: PersistentVolume
metadata:
  name: syslog-pv
spec:
  capacity:
    storage: "${var.logs-volume-size}Gi"
  csi:
    volumeHandle: ${aws_ebs_volume.websketchLogs.id}
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: topology.ebs.csi.aws.com/zone
          operator: In
          values:
          - ${aws_ebs_volume.websketchLogs.availability_zone}
  
---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: syslog-claim
spec:
  resources:
    requests:
      storage: "${var.logs-volume-size}Gi"

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: sketch-repo-pv
spec:
  capacity:
    storage: "${var.sketch-repo-volume-size}Gi"
  csi:
    volumeHandle: ${aws_ebs_volume.sketchRepo.id}
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: topology.ebs.csi.aws.com/zone
          operator: In
          values:
          - ${aws_ebs_volume.sketchRepo.availability_zone}
  
---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sketch-repo-claim
spec:
  resources:
    requests:
      storage: "${var.sketch-repo-volume-size}Gi"

---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: lti-db-pv
spec:
  capacity:
    storage: "${var.db-volume-size}Gi"
  csi:
    volumeHandle: ${aws_ebs_volume.ltiDb.id}
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: topology.ebs.csi.aws.com/zone
          operator: In
          values:
          - ${aws_ebs_volume.ltiDb.availability_zone}
  
---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: lti-db-claim
spec:
  resources:
    requests:
      storage: "${var.db-volume-size}Gi"

VOL_OVERLAY
}



output "vpc-id" {
  value = aws_vpc.websketch.id
}

output "sketchrepo-volume-id" {
  value = aws_ebs_volume.sketchRepo.id
}

output "logs-volume-id" {
  value = aws_ebs_volume.websketchLogs.id
}

output "db-volume-id" {
  value = aws_ebs_volume.ltiDb.id
}

resource "local_file" "config_map_aws_auth" {
  filename = "configmap-aws-auth.yaml"
  content = local.config_map_aws_auth
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig.yaml"
  content = local.kubeconfig
}

resource "local_file" "volumes-overlay" {
  filename = "${var.kustomize-output-path}/volumes.yaml"
  content = local.volumes-overlay
}
