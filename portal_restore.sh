cd playbook
touch portal_deployment.log
ansible-playbook -i inventory portal-restore.yml  --ask-become-pass -vvvv
