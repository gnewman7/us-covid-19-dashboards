
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

Edit the [.env](https://github.com/gnewman7/us-covid-19-dashboards/blob/master/.env) file be done before running docker-compose.

### Start the MySQL and Grafana Docker Containers

`$ docker-compose up -d`

```
Creating network "us-covid-19-dashboards_default" with the default driver
Creating grafana_covid ... done
Creating mysql_covid   ... done
```

## Show running docker processes
`$ docker ps`

```
CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                               NAMES
1ac0e442853b        mysql:5.7.24            "docker-entrypoint.s…"   5 seconds ago       Up 4 seconds        33060/tcp, 0.0.0.0:3307->3306/tcp   mysql_covid
05fe584ec6de        grafana/grafana:7.1.5   "/run.sh"                5 seconds ago       Up 4 seconds        0.0.0.0:3000->3000/tcp              grafana_covid
```

## Using MySQL 

```
$ docker exec -it mysql_covid bash

root@1ac0e442853b:/# ls sql

drwxr-xr-x 5 root root  160 Jul 25 16:32 .
drwxr-xr-x 1 root root 4096 Oct  2 19:41 ..
-rw-r--r-- 1 root root 3007 Jun 27 19:07 CreateTables.sql
-rw-r--r-- 1 root root  783 Sep 27 19:36 LoadData.sql
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

You should now see in the covid-19-data directory the following:
* LICENSE			
* `PROBABLE-CASES-NOTE.md`
* `README.md`		
* excess-deaths - directory
* live - directory
* us-counties.csv - file			
* us-states.csv	- file	
* us.csv - file

### Load Data using LoadData.sql script
This load the csv data into the following three tables:
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
[Log into Grafana Documentation](https://grafana.com/docs/grafana/latest/getting-started/getting-started/#log-in-for-the-first-time)

http://localhost:3000/login
* username = admin
* password = admin

* click skip

## Create a data source to connect to MySQL Docker container

[Adding Grafana Data Source Documentation](https://grafana.com/docs/grafana/latest/features/datasources/add-a-data-source/#add-a-data-source)

Hover over Configuration (Gear) -> Data Source -> Add data source -> Select MySQL

* Name = covid
* Host = mysql:3306
* Database = covid
* User = root
* Password = 123xxx (can change .env to your own password before staring containers)

Save & Test - button

Green Database Connection OK

## Import Grafana Dashboards

[Importing Grafana Dashboards Documentation](https://grafana.com/docs/grafana/latest/reference/export_import/#importing-a-dashboard)

* Hover on the + sign -> Import
* Click Upload .json file
* Select json file **covid-19 US.json** in the dashboards directory
* Select the data source covid
* Click the Import button
* Repeat for states and counties dashboards

You should now have three Grafana Dashboards
* Covid-19 US
* Covid-19 States
* Covid-19 US Counties

For more information on Grafana

* See [Grafana Documentation](https://grafana.com/docs/grafana/latest/?utm_source=grafana_gettingstarted)

For more information on MySQL

* See [MySQL Documentation](https://dev.mysql.com/doc/)

## Updating New York Times covid-19-data

Each day the New York Times updates their data on github. 

To update your local database do the following:

#### Go to covid data directory
`$ cd covid-19-data`
##### Check the repository

$ git remote -v

`origin	https://github.com/nytimes/covid-19-data (fetch)`

`origin	https://github.com/nytimes/covid-19-data (push)`

Pull in new data from NY Times remote repository

`$ git pull`

ReLoad Data Using MySQL Workbench
* File -> Open SQL Script 
* Select the sql directory in this project
* Select file **LoadData.sql**
* Then Run the sql script to ReLoad the data

### Shutdown MySQL and Grafana
From the us-covid-19-dashboards directory issue the following command:

`$ docker-compose down`

Stopping us-covid-19-dashboards_grafana_1 ... done

Stopping us-covid-19-dashboards_mysql_1   ... done

Removing us-covid-19-dashboards_grafana_1 ... done

Removing us-covid-19-dashboards_mysql_1   ... done

Removing network us-covid-19-dashboards_default

Now you can shutdown Docker Desktop.

Your data will be persisted locally after shutdown and available when restarting.

### Restarting MySQL and Grafana

* Make sure to start Docker
* From the us-covid-19-dashboards directory issue the following command:

`$ docker-compose up -d`