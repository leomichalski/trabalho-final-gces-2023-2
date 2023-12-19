# Change to match your CPU core count
workers 2

# Min and Max threads per worker
threads 10, 20

app_dir = "/decidim-govbr"

# # Specifies the `port` that Puma will listen on to receive requests; default is 3000.
# port ENV.fetch('PORT', 3000)

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "tcp://0.0.0.0:#{ENV['PORT'] || 3000}"

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  #ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
