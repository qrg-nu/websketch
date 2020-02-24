cd ../../../containers/websketch/
CALL build.bat
cd ..
CALL aws-push.bat websketch-server
cd ../stacks/aws-kub-stack/websketch/
kubectl rollout restart deployment/websketch-server -n websketch
