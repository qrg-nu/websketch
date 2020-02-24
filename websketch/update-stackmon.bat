cd ../../../containers/stackmon/
svn update
CALL build.bat
cd ..
CALL aws-push.bat websketch-stackmon stackmon
cd ../stacks/aws-kub-stack/websketch/
kubectl rollout restart deployment/stackmon -n websketch
