APP_CONFIG_FILE = "#{RAILS_ROOT}/config/papertrail.yml"

if File.exists?(APP_CONFIG_FILE)
  APP_CONFIG = YAML::load(File.open(APP_CONFIG_FILE))[RAILS_ENV]
else
  APP_CONFIG = {
    "title" => "Books",
    "author" => "Paper Trail",
    "blurb" => "",
    "perform_authentication" => true,
    "password" => "0123456789",
  }
end