#!/bin/bash

set -e

# runs db:drop, db:create and db:migrate.
# We can't use db:schema:load because we don't have the db/schema.rb
# file when we create the app for the first time and migrations haven't
# been run yet.
#bundle exec rake db:migrate:reset
# Adds basic system, admin and user accounts, and lorem ipsum content.
#bundle exec rake db:seed

#exec "$@"

rm -f tmp/pids/server.pid

# bundle check || bundle install

# webpack
bundle exec rails assets:precompile
bundle exec rails webpacker:compile

if [[ $RAILS_ENV == "development" ]]; then
  bash scripts/start_webpack_dev.sh &
fi

# mexer no banco de dados
if bundle exec rails db:exists; then
  bundle exec rails db:migrate
else
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
fi

# subir mailcatcher
mailcatcher --http-ip=0.0.0.0 &

# subir sidekiq
bundle exec sidekiq & 

# subir rails
bundle exec puma -C config/puma.rb
