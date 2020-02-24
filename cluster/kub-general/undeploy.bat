kubectl delete -k "https://github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

kubectl delete -f nginx-ingress-service.yaml
kubectl delete -f nginx-ingress-mandatory.yaml

kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml

kubectl delete -f metrics-server/deploy/kubernetes/
kubectl delete -f eks-admin-service-account.yaml

rmdir /S /Q metrics-server
