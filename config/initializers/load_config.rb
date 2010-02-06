APP_CONFIG_FILE = Rails.root.join("config", "papertrail.yml")

if File.exists?(APP_CONFIG_FILE)
  APP_CONFIG = YAML::load(File.open(APP_CONFIG_FILE))[Rails.env]
else
  APP_CONFIG = {
    "title" => "Books",
    "author" => "Paper Trail",
    "blurb" => "",
    "perform_authentication" => true
  }
end
