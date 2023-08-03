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