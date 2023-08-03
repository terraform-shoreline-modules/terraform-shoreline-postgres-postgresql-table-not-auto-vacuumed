#!/bin/bash

# Define the database name, user, and password

DB_NAME=${DATABASE_NAME}

DB_USER=${DATABASE_USER}

DB_PASS=${DATABASE_PASSWORD}

# Define the frequency and parameters for the vacuum process

VACUUM_FREQ="PLACEHOLDER" # e.g. 10000

VACUUM_SCALE_FACTOR="PLACEHOLDER" # e.g. 0.2

# Connect to the database and run the command to adjust the vacuum settings

psql -d $DB_NAME -U $DB_USER -c "ALTER SYSTEM SET autovacuum_vacuum_scale_factor = '$VACUUM_SCALE_FACTOR';"

psql -d $DB_NAME -U $DB_USER -c "ALTER SYSTEM SET autovacuum_vacuum_cost_limit = '$VACUUM_FREQ';"

psql -d $DB_NAME -U $DB_USER -c "SELECT pg_reload_conf();"


# Output a message indicating success

echo "Automatic vacuum process settings adjusted successfully"