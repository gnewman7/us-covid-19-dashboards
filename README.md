## Login into Grafana
http://localhost:3000/login
username admin
password admin

skip

## Create a data source to connect to MySQL Docker container
Configuration (gear) -> Data Source -> Add data source -> Select MySQL

Name = covid
Host = mysql:3306
Database = covid
User = root
Password = 123xxx (change .env to your own password)

Save & Test - button

Green Database Connection OK

## Import Dashboards
Hover on the + sign -> Import
Click Upload .json file

Select json files in the dashboards directory
covid-19 US.json
covid-19 States.json
covid-19 US Counties.json

Select the data source covid
Click the Import button
Repeat for states anc counties dashboards