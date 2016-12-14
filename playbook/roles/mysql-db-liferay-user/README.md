Liferay | DB | MySQL
=========

An Ansible role to install and configure MySQL database. 
By default it also creates `liferay` database and `liferay` user! 
However this can be easily configured and more/different databases/users can be provisioned. 

Requirements
------------

Tested on Ansible 1.9.2 but may also work with older versions 


Role Variables
--------------

```yaml
#
# where to copy provisioning related artifacts
#
remote_provisioning_folder: "~/.provisioning"

#
# folder to keep custom MySQL configuration files 
#
mysql_custom_config_folder: "/etc/mysql/custom.conf.d"

#
# Custom MySQL configuration files.
#
mysql_custom_configs:
 - {template: "bind-to-all.cnf.j2", filename: "bind-to-all.cnf"}

#
# A folder to copy SQL files to be imported if "import" is set 
# for any databse in "mysql_databases" property 
#
mysql_import_files_path: "{{ remote_provisioning_folder }}/mysql_import"

#
# MySQL databases to be created.
#
mysql_databases:
 - {name: "liferay", encoding: "utf8", collation: "utf8_general_ci"}
# - {name: "some_other_db", encoding: "utf8", collation: "utf8_general_ci" import="some_file.sql"}


#
# MySQL users to be created.
#
mysql_users:
 - {name: "liferay", host: "%", password: "liferay", priv: "liferay.*:ALL"}
# - {name: "other_user", host: "%", password: "secret", priv: "*.*:ALL"}

```

Dependencies
------------

None

Example Playbook
----------------

```yml
- hosts: dbservers
  roles:
  - role: milendyankov/liferay-db-mysql
    mysql_databases:
     - {name: "liferay", encoding: "utf8", collation: "utf8_general_ci"}
    mysql_users:
     - {name: "liferay", host: "%", password: "liferay", priv: "liferay.*:ALL"}
```

License
-------

BSD
