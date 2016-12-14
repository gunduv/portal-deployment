# portal-deployment
Ansible scripts for installing and deploying liferay portal.

Portal Deployment script is a combination of different roles and plays.
Roles:
- mysql-db-liferay-user: Installs mysql and creates mysql user
- liferay-portal: Installs Java and Liferay portal   
- portal-sdk: Deploys the application into liferay  
- backup: Creates Portal backup snapshot
- restore: Restores Portal snapshot

Plays:
- portal-deploy.yml: Scripts to install mysql, liferay and deploy the portal and application   
- portal-update.yml: Scripts to update the application on portal. 
- portal-backup.yml:  Scripts to create a snapshot of the portal application    
- portal-servers.yml: Scripts to start the servers  
- portal-restore.yml: Scripts to restore the portal snapshot  

How to run:
- portal_deploy.sh: Run to install mysql, liferay and deploy the portal and application  
- portal_update.sh: Run to update the application on portal.
- portal_backup.sh: Run to create a snapshot of the portal application
- portal_restore.sh: Run to restore the portal snapshot 



Requirements:
sdk_path = /home/{{user}}/portalsdk, path of the Liferay portal sdk, Inside portalsdk dist folder should contains all the war files required for liferay application.






