# portal-deployment
Ansible scripts for installing and deploying liferay portal.

Deployment script combination of different roles
- mysql-db-liferay-user: Installs mysql and creates mysql user
- liferay-portal: Installs Java and Liferay portal   
- portal-sdk: Deploys the application into liferay  
- backup: Creates Portal backup 
- restore: Restores Portal



Requirements:
sdk_path = /home/{{user}}/portalsdk, path of the Liferay portal dist folder exists, inside dist all the war files requires for liferay application are placed.






