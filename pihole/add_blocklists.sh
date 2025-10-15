#!/bin/bash

# Container name (change if you have a different one)
CONTAINER="pihole"

# File with lists (located next to the script)
ADLISTS_FILE="$(dirname "$0")/adlists.list"

DB_FILE="$(dirname "$0")/etc/gravity.db"

if [[ ! -f "$ADLISTS_FILE" ]]; then
  echo "File $ADLISTS_FILE not found!"
  exit 1
fi

# Add all entries from the file
while IFS='|' read -r COMMENT URL; do
  # skip empty lines and comments
  [[ -z "$COMMENT" || "$COMMENT" =~ ^# ]] && continue
  echo "Adding $COMMENT ..."
  sqlite3 $DB_FILE "INSERT OR IGNORE INTO adlist (address, enabled, comment) VALUES ('$URL', 1, '$COMMENT');"
done < "$ADLISTS_FILE"

# Update Pi-hole databases
docker exec -it "$CONTAINER" pihole -g

echo "Ready ✅"
