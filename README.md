# Filter Bubble Docker

This repository contains _Docker_ files which setup the _Passive Data Kit_ server.

## Background

Online and mobile news consumption leaves digital traces that are used to personalize news supply, possibly creating filter bubbles where people are exposed to a low diversity of issues and perspectives that match their preferences. The [JEDS Filter Bubble](http://ccs.amsterdam/projects/jeds/) project aims to understand the filter bubble effect by performing deep semantic analyses on mobile news consumption traces. This project is a collaboration between the [VU](https://www.vu.nl/nl/index.aspx), the [UvA](http://www.uva.nl/) and [NLeSC](https://www.esciencecenter.nl/), lead by [Wouter van Atteveldt](http://vanatteveldt.com/).

Part of this project makes use of the [Passive Data Kit](https://passivedatakit.org/) server, developed by [Chris Karr](https://audacious-software.com/). This server gathers browsing history from each participant in a database. The _Docker_ files contained in this repository help setup the server as a _Python Django_ app. See the [Passive Data Kit documentation](https://passivedatakit.org/getting-started/django-server) for additional information.

## Installation

### Prerequisites

- Clone the repository and its submodule using `git clone --recurse-submodules`.
- On your server, install `docker`, `docker-compose` and a mail application (e.g. `mailutils` or `sendmail`, for _Cron_ emails)
- Make sure nothing is running at _PostGres_ port 5432 (or kill it using `sudo kill $(sudo lsof -t -i:5432)`)

### Initial setup

- Rename `variables.env.template` to `variables.env` and configure the variables
- Run `chmod +x backuppostgres.sh` to allow _Cron_ to execute the backup script

### Build the Docker image

- Run `sudo docker-compose up -d` to build the Docker image and run the container
- Run `sudo docker-compose exec django python manage.py createsuperuser` to setup the administrative access

### Setup Cron

- Run `sudo crontab crontab` to load the `crontab` file (the last argument is the filename)
- Run `sudo service cron start` to start the _Cron_ service

### Additional commands

- Run `sudo docker ps` to list all containers which are running
- Run `sudo docker exec -it [container-id] bash` to enter a container and execute bash commands
- Run `sudo docker-compose down` to stop containers which are running
- Run `sudo docker rm $(sudo docker ps -a -q)` to delete all _Docker_ containers
- Run `sudo docker rmi $(sudo docker images -q)` to delete all _Docker_ images
- Run `sudo service [name] status` to see if a service (e.g. `cron` or `sendmail`) is running
- Run `sudo service [name] stop` to stop the service (e.g. `cron` or `sendmail`)
- Run `sudo crontab -l` to list all current _Cron_ jobs
- Run `sudo crontab -e` to edit the current _Cron_ file
- Run `sudo crontab -r` to delete/reset all _Cron_ jobs
- Run `git submodule foreach git pull origin master` to pull the latest commit for each submodule.

## Repository content

### Web-Historian-Server

This directory contains the [Web Historian Server](https://github.com/audaciouscode/Web-Historian-Server) submodule which contains the _Passive Data Kit_ configured for use with the _Web Historian_ browser extension.

### backuppostgres.sh

The `backuppostgres.sh` contains a command which exports the content of the _PostGres_ database to a file on the server. It starts overwriting old files after one month.

### crontab

The `crontab` contains a list of _Cron_ jobs to be executes regularly. See the [Passive Data Kit documentation](https://passivedatakit.org/getting-started/django-server) for additional information. If any errors occur, these are emailed to the configured email address.

### Dockerfile

The `Dockerfile` describes the _Docker_ image that will be created for this application. The _Passive Data Kit_'s development targets the latest _Long Term Support_ (LTS) versions of _Django_. This _Docker_ image contains _Python 2.7_. _Passive Data Kit_ uses _GeoDjango_ and the _Postgres_ database's native _GIS_ features to implement some location-based features used to support data quality monitoring and other analysis tools. This requires the `python-pdal` package. When a data export is requested in the _Passive Data Kit_ server dashboard, a file is generated and e-mailed to the requester. This requires a mail application such as the `sendmail` package.  The local settings, which are not included in the _Passive Data Kit_ submodule and which contain information specific to the current setup, are copied into the main _Django_ directory. Finally, all requirements, including _Django version 1.11.20_, are installed.

### docker-compose.yml

The `docker-compose.yml` file describes the structure of the _Docker_ containers. This includes the _Django_ app, the _PostGres_ database, the _nginx_ web server and the _Let's Encrypt_ _SSL_ certificates service. When the _Django_ app is first run, a command is executed which i.a. runs the _Django_ migration.

### local-settings.py

The local settings contain some specific settings for _Django_ which are specific to the current setup. The file works in conjunction with `variable.env` which contains the actual variables.

### nginx.conf

This configuration file tell _nginx_ how to set up the server for the _Django_ app.

### variable.env.template

This template should be renamed to `variable.env` and edited to include the relevant user names, host names and passwords.
