cd ../../../containers/auth-node-lti/
svn update
CALL build.bat
cd ..
CALL aws-push.bat websketch-auth-node-lti auth-node-lti
cd ../stacks/aws-kub-stack/websketch/
kubectl rollout restart deployment/lti-authnode -n websketch
