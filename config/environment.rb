# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  config.time_zone = 'London'
  
  config.action_controller.session = {
    :session_key => "_papertrail_session",
    :secret => "7c911fb269c1733f19ec5ac4457dd7e2aa62c9135a5e5d13476be5816960958789479d39b3c349cd646f87f3e379322254467dda1ac4cca6f2e2b4f20930a686"
  }
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
end
