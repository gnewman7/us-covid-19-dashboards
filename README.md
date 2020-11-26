
# us-covid-19-dashboards
This open source project is provided `as is` to users wanting to create dashboard visualizations of New York Times covid-19 data locally on their desktop using a MySQL database and Grafana open source software running in Docker containers.

## Install Docker for Desktop
Make sure you have Docker installed on desktop.
[Directions to Install Docker for Mac or Windows](https://docs.docker.com/get-started/#download-and-install-docker-desktop)


## MySQL and Grafana Docker Containers
Once you have Docker running you are ready to start the MySQL and Grafana containers included in the docker-compose.yml file

Go to your project directory **us-covid-19-dashboards**

If your wish to change 
* version of MySQL or Grafana
* Ports used
* DB Password

Edit the [.env](https://github.com/gnewman7/us-covid-19-dashboards/blob/master/.env) file before running docker-compose.

```
# Ports
MYSQL_PORT=3307
GRAFANA_PORT=3000

# Versions
GRAFANA_CONTAINER_VERSION=7.3.4
MYSQL_VERSION=5.7.24

# Change DB_PASS
DB_USER=root
DB_PASS=123xxx
```

### Start the MySQL and Grafana Docker Containers

`$ docker-compose up -d`

```
Creating network "us-covid-19-dashboards_default" with the default driver
Creating mysql_covid-19 ... done
Creating grafana_covid-19 ... done

```

## Show running docker processes
`$ docker ps`

```
CONTAINER ID        IMAGE                   COMMAND                  CREATED              STATUS              PORTS                               NAMES
eb022286b379        grafana/grafana:7.3.4   "/run.sh"                About a minute ago   Up About a minute   0.0.0.0:3000->3000/tcp              grafana_covid-19
c1e33dc2475c        mysql:5.7.24            "docker-entrypoint.s…"   About a minute ago   Up About a minute   33060/tcp, 0.0.0.0:3307->3306/tcp   mysql_covid-19
```

## Show running docker-compose processes
`$ docker-compose ps`

```
      Name                    Command               State                 Ports              
---------------------------------------------------------------------------------------------
grafana_covid-19   /run.sh                          Up      0.0.0.0:3000->3000/tcp           
mysql_covid-19     docker-entrypoint.sh mysql ...   Up      0.0.0.0:3307->3306/tcp, 33060/tcp
```


## Using MySQL 

```
$ docker exec -it mysql_covid-19 bash

root@1ac0e442853b:/# ls -la sql

drwxr-xr-x 4 root root  128 Nov 26 00:44 .
drwxr-xr-x 1 root root 4096 Nov 26 01:58 ..
-rw-r--r-- 1 root root 3031 Nov 26 00:44 CreateTables.sql
-rw-r--r-- 1 root root  783 Nov 26 00:44 LoadData.sql

```

### SQL Scripts
Included are two sql scripts
* CreateTables.sql - Creates the database, the tables, and views
* LoadData.sql - This sql script is used to load the NYTimes csv data that is updated daily. It used the REPLACE syntax to reload data from scratch.

### Using MySQL monitor
To connect to the MySQL monitor enter the following command followed by the mysql password you enter in your .env file.

```
root@1ac0e442853b:/# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.24-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

```


### Create Database Schema
* From the mysql> prompt run the CreateTables.sql script as follows:

```
mysql> source ./sql/CreateTables.sql;
Query OK, 1 row affected (0.00 sec)

Database changed
Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

Query OK, 0 rows affected (0.00 sec)
```

#### Tables
* us
* us_states
* us_counties

#### Views
* us_case_rate_vw
* us_county_case_rate_vw
* us_county_death_rate_vw
* us_death_rate_vw
* us_states_case_rate_vw
* us_states_death_rate_vw

```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| covid              |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

mysql> use covid;
Database changed
mysql> show tables;
+-------------------------+
| Tables_in_covid         |
+-------------------------+
| us                      |
| us_case_rate_vw         |
| us_counties             |
| us_county_case_rate_vw  |
| us_county_death_rate_vw |
| us_death_rate_vw        |
| us_states               |
| us_states_case_rate_vw  |
| us_states_death_rate_vw |
+-------------------------+
9 rows in set (0.00 sec)
```

## Loading covid-19-data
The covid-19 data used in this project is published by the New York Times in the following github repository:

https://github.com/nytimes/covid-19-data

It has been added to this project as a submodule

To initialize data in the **covid-19-data** directory run the following command:

`git submodule update --init --recursive`

You should now see in the covid-19-data directory the following files and directories:

* LICENSE
* NEW-YORK-DEATHS-METHODOLOGY.md
* PROBABLE-CASES-NOTE.md
* README.md
* colleges
* excess-deaths
* live
* mask-use

* us.csv
* us-counties.csv
* us-states.csv


### Load Data using LoadData.sql script
This script loads the csv data into the following three tables:
* us
* us_states
* us_counties
```
source ./sql/LoadData.sql;
Query OK, 254 rows affected (0.01 sec)
Records: 254  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 11674 rows affected (0.17 sec)
Records: 11674  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 586302 rows affected (6.77 sec)
Records: 586302  Deleted: 0  Skipped: 0  Warnings: 0
```

## Using Grafana to View Covid Dashboards

### Login into Grafana
[View Grafana Documentation](https://grafana.com/docs/grafana/latest/getting-started/getting-started/#log-in-for-the-first-time)

http://localhost:3000/login
* username = admin
* password = admin

* click skip


You should now have three Grafana Dashboards that display Covid-19 statistics
* United States of America
* States
* US Counties

For more information on Grafana

* See [Grafana Documentation](https://grafana.com/docs/grafana/latest/?utm_source=grafana_gettingstarted)

For more information on MySQL

* See [MySQL Documentation](https://dev.mysql.com/doc/)

## Updating New York Times covid-19-data

Each day the New York Times updates their data on github. 

To update your local database do the following:

### Go to covid data directory
`$ cd covid-19-data`

#### Check the repository

`$ git remote -v`

```
origin	https://github.com/nytimes/covid-19-data (fetch)
origin	https://github.com/nytimes/covid-19-data (push)
```
### Pull in new data from NY Times remote repository

`$ git pull origin master`

### ReLoad Data

```
$ docker exec -it mysql_covid-19 bash
root@c1e33dc2475c:/# mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.24-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> source ./sql/LoadData.sql;
Query OK, 309 rows affected (0.02 sec)
Records: 309  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 14699 rows affected (0.68 sec)
Records: 14699  Deleted: 0  Skipped: 0  Warnings: 0

Query OK, 764735 rows affected (34.04 sec)
Records: 764735  Deleted: 0  Skipped: 0  Warnings: 0

mysql> exit
root@c1e33dc2475c:/# exit
$ 

```

### Shutdown MySQL and Grafana
From the us-covid-19-dashboards directory issue the following command:

`$ docker-compose down`

```
Stopping grafana_covid-19 ... done
Stopping mysql_covid-19   ... done
Removing grafana_covid-19 ... done
Removing mysql_covid-19   ... done
Removing network us-covid-19-dashboards_default
```

Now you can shutdown Docker Desktop.

Your data will be persisted locally after shutdown and available when restarting.

### Restarting MySQL and Grafana

* Make sure to start Docker
* From the us-covid-19-dashboards directory issue the following command:

`$ docker-compose up -d`
