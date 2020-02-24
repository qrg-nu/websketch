kubectl taint node -l nodeSpecialization=websketch key=websketch:PreferNoSchedule

@echo.
@echo Deploying Kubernetes Metrics Server ...
rmdir /S /Q metrics-server
git clone https://github.com/kubernetes-sigs/metrics-server.git
kubectl apply -f eks-admin-service-account.yaml
kubectl apply -f metrics-server/deploy/kubernetes/

@echo.
@echo Deploying Kubernetes Dashboard ...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml

@echo.
@echo Deploying NGINX Ingress Controller ...
kubectl apply -f nginx-ingress-mandatory.yaml
kubectl apply -f nginx-ingress-service.yaml

@echo.
@echo Deploying AWS EBS CSI Driver ...
kubectl apply -k "https://github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
