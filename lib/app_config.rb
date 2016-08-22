module AppConfig
  CFG_FILE = File.join(Rails.root,"config","app_config.yml")
  DEFAULTS_FILE = File.join(Rails.root,"config","app_config_defaults.yml")
  ENV = Rails.env == "test" ? "development" : Rails.env
   
  @@loaded_at=nil
  
  def self.load_config
    @@loaded_at = Time.now
    @@cfg=YAML.load_file(CFG_FILE)
  end
  
  def self.save_config(config)
    File.open(CFG_FILE,'w') do |h| 
      h.write config.to_yaml
    end
  end
  
  def self.get(*keys)
    if @@loaded_at.nil? || @@loaded_at < modified_at
      load_config
    end
    pointer=@@cfg[ENV]
    keys.each do |key|
      pointer=pointer[key]
      return nil if pointer.nil?
    end
    pointer = nil if pointer==""
    pointer
  end
  
  def self.set(*keys,value)
    if updated_or_not_loaded?
      load_config
    end
    last_key = keys.pop
    stack=[]
    stack.push @@cfg[ENV]
    keys.each do |key|
      stack.last[key]||={}
      stack.push stack.last[key] 
    end
    stack.last[last_key]=value
    save_config @@cfg
  end
  
  def self.modified_at
    File.mtime CFG_FILE
  end
  
  def self.updated_or_not_loaded?
    @@loaded_at.nil? || @@loaded_at < modified_at
  end
  
  # initiate config with any new defaults that not yet exits, keep existing 1st level values as they are
  def self.initialize_config
    defaults = YAML.load_file(DEFAULTS_FILE)
    load_config
    @@cfg[ENV].merge!(defaults) do |key, oldval, newval|
      oldval
    end
    save_config @@cfg
  end
  
  # replace config with provided config value, overwrite any existing values
  def self.update(config)
    load_config
    @@cfg[ENV].merge!(config) do |key, oldval, newval|
      newval
    end
    save_config @@cfg
  end
end