namespace :app do
  desc "Updates the application after patching"
  task :update do
    Rake::Task['assets:precompile'].invoke(RAILS_ENV=ENV["RAILS_ENV"])
    Rake::Task['db:migrate'].invoke(RAILS_ENV=ENV["RAILS_ENV"])
    Rake::Task['db:seed'].invoke(RAILS_ENV=ENV["RAILS_ENV"])
    #Rake::Task['clean'].invoke
    Rake::Task['tmp:clear'].invoke
    #Rake::Task['report:redefine'].invoke
    puts "Application updated"
  end
  
  desc "Initializes app_config with new parameters from app_config_defaults"
  task :init_config => :environment do
    AppConfig.initialize_config
    puts "Config initialized."
  end
end