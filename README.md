# portal-deployment
Ansible scripts for installing and deploying liferay portal.

Plays:
- portal_deploy.sh: run to install mysql, liferay and deploy the portal and application  
- portal_update.s: run to update the application on portal.
- portal_backup.sh: run to create a snapshot of the portal application
- portal_restore.sh: run to restore the portal snapshot 

Deployment script combination of different roles
- mysql-db-liferay-user: Installs mysql and creates mysql user
- liferay-portal: Installs Java and Liferay portal   
- portal-sdk: Deploys the application into liferay  
- backup: Creates Portal backup 
- restore: Restores Portal



Requirements:
sdk_path = /home/{{user}}/portalsdk, path of the Liferay portal sdk, Inside portalsdk dist folder should contains all the war files required for liferay application.






