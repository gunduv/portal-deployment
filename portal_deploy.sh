cd playbook
touch portal_deployment.log
ansible-playbook -i inventory portal-deploy.yml  --ask-become-pass -vvvv
ansible-playbook -i inventory portal-servers.yml -vvv


