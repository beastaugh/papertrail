require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Papertrail
  class Application < Rails::Application
    # Make Active Record use UTC-base instead of local time
    config.active_record.default_timezone = :utc
    config.time_zone = 'London'
    
    config.action_controller.session = {
      :session_key => "_papertrail_session",
      :secret => "7c911fb269c1733f19ec5ac4457dd7e2aa62c9135a5e5d13476be5816960958789479d39b3c349cd646f87f3e379322254467dda1ac4cca6f2e2b4f20930a686"
    }
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )
    
    config.load_paths << Rails.root.join("app", "sweepers")
    
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
    
    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de
    
    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end
    
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
  end
end
