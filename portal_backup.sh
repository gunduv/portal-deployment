echo "start"
echo $1
cd $1/playbook
touch portal_deployment.log
ansible-playbook -i inventory portal-backup.yml -vvvv
echo "end"
