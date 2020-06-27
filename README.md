
# us-covid-19-dashboards
This open source project is provided `as is` to users wanting to create dashboard visualizations of New York Times covid-19 data locally on their desktop using a MySQL database and Grafana open source software running in Docker containers.

## Install Docker for Desktop
Make sure you have Docker installed
Follow direction to install for Mac or Windows
https://docs.docker.com/get-started/#download-and-install-docker-desktop

## Start MySQL and Grafana Docker Containers
Once you have Docker running you are ready to start the MySQL and Grafana container included in the docker-compose.yml file

Go to your project directory

The command below will start the MySQL and Grafana Docker Containers

`$ docker-compose up -d`

`Creating network "us-covid-19-dashboards_default" with the default driver`

`Creating us-covid-19-dashboards_grafana_1 ... done`

`Creating us-covid-19-dashboards_mysql_1   ... done`

## Show running docker processes
`$ docker ps`

`CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                               NAMES`

`31baf02fb715        grafana/grafana:7.0.2   "/run.sh"                43 minutes ago      Up 43 minutes       0.0.0.0:3000->3000/tcp              us-covid-19-dashboards_grafana_1`

`c9a8c93f13e8        mysql:5.7.24            "docker-entrypoint.s…"   43 minutes ago      Up 43 minutes       33060/tcp, 0.0.0.0:3307->3306/tcp   us-covid-19-dashboards_mysql_1`

## Using MySQL Workbench 
Install MySQL Workbench for your desktop following instruction on website
https://www.mysql.com/products/workbench/

### Start MySQL Workbench and Create a MySQL Connection
* Connection Name = Docker MySQL
* Connection Method = Standard (TCP/IP)
* Hostname = 127.0.0.1
* Port = 3307
* Username = root

Click on MySQL Connection 
Enter password when prompted

### Create Database Schema
* File -> Open SQL Script 
* Select the sql directory in this project
* Select file [CreateTables.sql](https://github.com/gnewman7/us-covid-19-dashboards/blob/master/sql/CreateTables.sql)
* Run the sql script to create the following tables and views:

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

## Loading the New York Times covid-19-data
The covid-19 data used in this project is published by the New York Times in the following github repository:

https://github.com/nytimes/covid-19-data

It has been added to this project as a submodule

To initialize data to the covid-19-data directory run the following command:

`git submodule update --init --recursive`

$ cd covid-19-data
$ ls -la

You should now see in the covid-19-data directory the following:
* LICENSE			
* `PROBABLE-CASES-NOTE.md`
* `README.md`		
* excess-deaths - directory
* live - directory
* us-counties.csv - file			
* us-states.csv	- file	
* us.csv - file

Load Data Using MySQL Workbench
* File -> Open SQL Script 
* Select the sql directory in this project
* Select file [LoadData.sql](https://github.com/gnewman7/us-covid-19-dashboards/blob/master/sql/LoadData.sql#L5)
* Change lines 5,17, and 29 to reflect the file path on your system.
* Then Run the sql script to Load the data



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

Select json files in the dashboards directory
* covid-19 US.json
* covid-19 States.json
* covid-19 US Counties.json

* Select the data source covid
* Click the Import button
* Repeat for states anc counties dashboards

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

Now you can shutdown Docker Desktop
Your data will be persisted locally after shutdown and available when restarting.

### Restarting MySQL and Grafana

* Make sure to start Docker
* From the us-covid-19-dashboards directory issue the following command:

`$ docker-compose up -d`