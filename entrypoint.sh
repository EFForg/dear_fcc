#!/bin/sh

attempts=0
while [ $attempts -lt 3 ]; do
    if bundle exec rake db:migrate 2>/dev/null; then
       break
    else
        attempts=$(($attempts + 1))
    fi
done
    
bundle exec rake dear_fcc:cc

exec "$@"
