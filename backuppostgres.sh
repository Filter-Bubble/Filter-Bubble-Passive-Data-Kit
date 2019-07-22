#!/bin/sh

. /home/jeds/filter-bubble-docker/variables.env

eval "docker run -i --network=filter-bubble-docker_default mdillon/postgis:9.6 pg_dump --dbname=postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:5432/$POSTGRES_DATABASE > /home/jeds/filter-bubble-docker/backups/backup.sql"
