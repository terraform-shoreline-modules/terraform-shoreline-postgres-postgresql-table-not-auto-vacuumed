
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Postgresql table not auto vacuumed incident
---

This incident type refers to situations where a Postgresql table has not been vacuumed automatically, causing potential performance issues. Vacuuming is a process that frees up space and improves performance by removing dead rows and updating statistics. Failure to vacuum a table can result in degraded database performance and slow query execution times. This incident type requires immediate attention to prevent further performance degradation and optimize database performance.

### Parameters
```shell
# Environment Variables

export TABLE_NAME="PLACEHOLDER"

export DATABASE_USER="PLACEHOLDER"

export DATABASE_PASSWORD="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"
```

## Debug

### Check if vacuum is enabled on the specific table
```shell
sudo -u postgres psql -c "SELECT relname, n_live_tup, last_vacuum, last_analyze FROM pg_stat_user_tables WHERE relname='${TABLE_NAME}'"
```

### Check if auto-vacuum is enabled on the specific table
```shell
sudo -u postgres psql -c "SELECT relname, autovacuum_enabled, autovacuum_vacuum_scale_factor, autovacuum_analyze_scale_factor FROM pg_stat_user_tables WHERE relname='${TABLE_NAME}'"
```

### Check the vacuum and analyze status of the specific table
```shell
sudo -u postgres psql -c "SELECT relname, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze FROM pg_stat_user_tables WHERE relname='${TABLE_NAME}'"
```

### Check the vacuum and analyze details of the specific table
```shell
sudo -u postgres psql -c "SELECT * FROM pgstattuple('${TABLE_NAME}')"
```

### Force an analyze on the specific table
```shell
sudo -u postgres psql -c "ANALYZE ${TABLE_NAME}"
```

### The autovacuum process may not be enabled or configured properly in the database, causing tables to not be vacuumed automatically.
```shell
bash

#!/bin/bash

# Set database credentials

DB_USER=${DATABASE_USER}

DB_PASSWORD=${DATABASE_PASSWORD}

DB_NAME=${DATABASE_NAME}

DB_HOST=${DATABASE_HOST}



# Check if autovacuum process is enabled and properly configured

autovacuum=$(psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "SELECT name, setting FROM pg_settings WHERE name IN ('autovacuum', 'autovacuum_vacuum_scale_factor', 'autovacuum_analyze_scale_factor', 'autovacuum_vacuum_cost_limit', 'autovacuum_vacuum_cost_delay')")



# Check if autovacuum is enabled

if echo "$autovacuum" | grep -q "on"; then

  echo "Autovacuum process is enabled"

else

  echo "Autovacuum process is not enabled"

fi

# Check if autovacuum scale factors are properly configured

if echo "$autovacuum" | grep -q "0.2"; then

  echo "Autovacuum scale factors are properly configured"

else

  echo "Autovacuum scale factors are not properly configured"

fi

# Check if autovacuum cost limit and delay are properly configured

if echo "$autovacuum" | grep -q "5000"; then

  echo "Autovacuum cost limit and delay are properly configured"

else

  echo "Autovacuum cost limit and delay are not properly configured"

fi
```

## Repair

### Force a vacuum on the specific table
```shell

sudo -u postgres psql -c "VACUUM ${TABLE_NAME}"

```


### Manually vacuum the affected table(s) to free up space and update statistics using the VACUUM command.
```shell

#!/bin/bash

# Set variables

DB_NAME=${DATABASE_NAME}

TABLE_NAME=${TABLE_NAME}

# Connect to the database

psql $DB_NAME <<EOF

# Vacuum the table

VACUUM $TABLE_NAME;

EOF

# Display success message

echo "Table $TABLE_NAME has been vacuumed successfully."

```

### Adjust the automatic vacuum process settings to ensure that it runs more frequently or with different parameters that are more appropriate for your database workload.
```shell
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


```