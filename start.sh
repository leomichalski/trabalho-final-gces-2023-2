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

# webpack
bundle exec rails assets:precompile
bundle exec rails webpacker:compile

# mexer no banco de dados
if bundle exec rails db:exists; then
  bundle exec rails db:migrate
else
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
fi

# already created by docker volume
# mkdir -p log
touch log/puma.stdout.log

# already created by docker volume
# mkdir -p tmp/pids
touch tmp/pids/puma.pid
touch tmp/pids/puma.state

bundle exec puma -C setup/puma/puma.production.rb
