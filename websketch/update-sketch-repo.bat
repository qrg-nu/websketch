cd ../../../containers/sketch-repo/
svn update
CALL build.bat
cd ..
CALL aws-push.bat sketch-repo
cd ../stacks/aws-kub-stack/websketch/
kubectl rollout restart -n websketch deployment/sketch-repo 
