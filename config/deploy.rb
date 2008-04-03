set :application, "papertrail"
set :domain, "books.extralogical.net"
set :deploy_to, "/home/ionfish/public_html/books.extralogical.net"
set :repository, "https://svn.extralogical.net/papertrail/trunk"
set :config_files, ["database.yml", "papertrail.yml"]
set :web_command, "true"

namespace :vlad do
  
  desc "Symlink config files into the Rails config directory."
  remote_task :link_config do
    config_files.each do |file|
      begin
        run "ln #{shared_path}/config/#{file} #{release_path}/config/#{file}"
      rescue Exception
        puts "Something went wrong with the link."
      end
    end
  end
  
  desc "Symlink Edge Rails to the /vendor/rails directory."
  remote_task :link_rails do
    begin
      run "ln -s ~/sources/rails #{current_release}/vendor/rails"
    rescue Exception
      puts "Couldn't link Rails."
    end
  end
  
  task :update do 
    Rake::Task['vlad:link_rails'].invoke
    Rake::Task['vlad:link_config'].invoke
  end
  
  desc "Full deploy: updates to the latest version, migrates the database, then starts the application." 
  task :deploy => [:update, :migrate, :start_app]
    
end
