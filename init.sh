#!/bin/bash
set -e

PAGE_CRAWLER_DB_PORT="${PAGE_CRAWLER_DB_PORT:-5432}"

echo "Waiting postgres be available"

MAX_TRIES=10
TRIES=0
until nc -z "$PAGE_CRAWLER_DB_HOST" "$PAGE_CRAWLER_DB_PORT"; do
    sleep 2
    TRIES=$(($TRIES + 1))
    if [ "$TRIES" = "$MAX_TRIES" ]; then
        echo "The max of $MAX_TRIES tries for waiting postgres has been reached."
        exit 1
    fi
done

echo "Postgres is ready"

bundle exec rake db:migrate RAILS_ENV=production

rails server -b 0.0.0.0