
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