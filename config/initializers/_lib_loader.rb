#requiring all in lib directory
Dir["#{Rails.root.to_s}/lib/*"].each do |file|
  require file if File.file? file
end

BEARS = YAML.load_file("#{Rails.root}/config/bears.yml")