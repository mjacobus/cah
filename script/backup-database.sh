#!/bin/bash

set -e
# Fetch the database URL from Heroku
DATABASE_URL=$(heroku config:get DATABASE_URL)

# Parse the URL to extract components
regex='mysql2://([^:]+):([^@]+)@([^:]+):([^/]+)/(.+)'
if [[ $DATABASE_URL =~ $regex ]]; then
	USERNAME=${BASH_REMATCH[1]}
	PASSWORD=${BASH_REMATCH[2]}
	HOST=${BASH_REMATCH[3]}
	PORT=${BASH_REMATCH[4]}
	DATABASE=${BASH_REMATCH[5]}
fi

# Create a dump of the database
mysqldump -h $HOST -P $PORT -u $USERNAME -p$PASSWORD $DATABASE >backup.sql

echo "Backup completed: backup.sql"
