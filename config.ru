# This file is used by Rack-based servers to start the application.
# The first line starting with #\ is treated as if it were options,
# allowing rackup arguments to be specified in the config file. #\ -s puma

require ::File.expand_path('../config/environment', __FILE__)

Rails.application.config.relative_url_root = ENV['RAILS_RELATIVE_URL_ROOT']

map Rails.application.config.relative_url_root || '/' do
  run Rails.application
end
