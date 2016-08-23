require 'test_helper'

class TestAppConfig < Minitest::Test
  def setup
    AppConfig.load_config
    AppConfig.set "test","subtest", 1
    AppConfig.set "shallow", 1
    
    # update default with testing value
    defaults = YAML.load_file(AppConfig::DEFAULTS_FILE)
    defaults["test"]={}
    defaults["test"]["subtest"]=3
    defaults["newkey"]="newkey"
    
    File.open(AppConfig::DEFAULTS_FILE,'w') do |h| 
      h.write defaults.to_yaml
    end
  end
  
  def teardown
    cfg = AppConfig.class_variable_get(:@@cfg)
    cfg["development"].delete("test")
    cfg["development"].delete("shallow")
    cfg["development"].delete("newkey")
    File.open(AppConfig::CFG_FILE,'w') do |h| 
      h.write cfg.to_yaml
    end
    
    defaults = YAML.load_file(AppConfig::DEFAULTS_FILE)
    defaults.delete("test")
    defaults.delete("newkey")
    File.open(AppConfig::DEFAULTS_FILE,'w') do |h| 
      h.write defaults.to_yaml
    end
  end
  
  def deep_copy(o)
    Marshal.load(Marshal.dump(o))
  end

  
  def test_set_keys
    assert_equal 1, YAML.load_file(AppConfig::CFG_FILE)["development"]["test"]["subtest"]
  end
  
  def test_set_new_keys
    # simulation 3rd party config change
    cfg = AppConfig.class_variable_get(:@@cfg)
    cfg["development"].delete("set_testing")
    File.open(AppConfig::CFG_FILE,'w') do |h| 
      h.write cfg.to_yaml
    end
    AppConfig.set "set_testing","subtest", 1
    assert_equal 1, AppConfig.get("set_testing","subtest")
    # simulation 3rd party config change
    cfg = AppConfig.class_variable_get(:@@cfg)
    cfg["development"].delete("set_testing")
    File.open(AppConfig::CFG_FILE,'w') do |h| 
      h.write cfg.to_yaml
    end
  end
  
  def test_get_keys
    assert_equal 1, AppConfig.get("test","subtest")
  end
  
  def test_get_nonexistent_keys
    assert_nil AppConfig.get("get_testing","subtest")
  end
  
  def test_set_and_get
    AppConfig.set "test","subtest", 2
    assert_equal 2, AppConfig.get("test","subtest")
  end
  
  def test_manual_set_and_get
    # simulation 3rd party config change
    cfg = AppConfig.class_variable_get(:@@cfg)
    cfg["development"]["test"]["subtest"]=3
    File.open(AppConfig::CFG_FILE,'w') do |h| 
      h.write cfg.to_yaml
    end
    assert_equal 3, AppConfig.get("test","subtest")
  end
  
  def test_modified_at
    t1 = AppConfig.modified_at
    sleep 1
    AppConfig.set "test", "subtest", 2
    t2 = AppConfig.modified_at
    assert t2 > t1
  end
  
  def test_updated_or_not_loaded
    sleep 1
    # simulation 3rd party config change
    cfg = AppConfig.class_variable_get(:@@cfg)
    cfg["development"]["test"]["subtest"]=3
    File.open(AppConfig::CFG_FILE,'w') do |h| 
      h.write cfg.to_yaml
    end
    assert AppConfig.updated_or_not_loaded?
    AppConfig.get "test", "subtest"
    refute AppConfig.updated_or_not_loaded?
    AppConfig.class_variable_set(:@@loaded_at,nil)
    assert AppConfig.updated_or_not_loaded?
  end
  
  def test_update
    # read config and change from 1 to 3
    cfg = deep_copy(AppConfig.class_variable_get(:@@cfg)["development"])
    cfg["test"]["subtest"]=3
    v1 = AppConfig.get "test", "subtest"
    assert_equal 1, v1
    AppConfig.update(cfg)
    v2 = AppConfig.get "test", "subtest"
    #config contains new value after update
    assert_equal 3, v2
    
    # same for shallow value
    cfg["shallow"]=3
    AppConfig.update(cfg)
    v2 = AppConfig.get "shallow"
    assert_equal 3, v2
  end
  
  def test_initialize
    # at this point subtest is 1 in config and 3 in defaults
    AppConfig.initialize_config
    #test already exits, it wont be touched
    assert_equal 1, AppConfig.get("test", "subtest")
    # newkey will be created
    assert_equal "newkey", AppConfig.get("newkey")
  end
end