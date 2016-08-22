require "minitest/autorun"
require_relative '../../lib/bears_logger.rb'
class TestBearsLogger < Minitest::Test
  
  def setup
    @filename = File.join(File.dirname(__FILE__),"bears_logger_test.log")
  end
  
  def teardown
    begin 
      File.delete @filename
    rescue
      File.open(@filename, 'w') {|file| file.truncate(0) }
    end  
  end
  
  def readfile(file)
    File.read(file)
  end
  
  def flush(logger)
    logger.instance_variable_get(:@logdev).instance_variable_get(:@dev).fsync
  end
  
  def test_sync_flag
    # if production the behaviour is the same
    Rails.stub :env, "production" do
      assert BearsLogger.send(:use_sync?, true) 
      assert_equal BearsLogger.send(:use_sync?, false), false
    end
    # for dev it is always true
    Rails.stub :env, "development" do
      assert BearsLogger.send(:use_sync?, true) 
      assert BearsLogger.send(:use_sync?, false)
    end
    # for test it is always true
    Rails.stub :env, "test" do
      assert BearsLogger.send(:use_sync?, true) 
      assert BearsLogger.send(:use_sync?, false)
    end
  end
  
  def test_logger_creates_file
    BearsLogger.initiate_logging(@filename)
    assert File.exist? @filename
  end
  
  def test_initiate_logging_level
    Rails.stub :env, "production" do
      log = BearsLogger.initiate_logging(@filename,level:Logger::INFO)
      # do not log debug
      log.debug "Debug Message"
      content = readfile(@filename)
      flush log
      assert_empty content
      # log info
      log.info "Info Message"
      flush log
      content = readfile(@filename)
      refute_empty content
    end  
  end
  
  def test_filename
    log = BearsLogger.initiate_logging(@filename,level:Logger::INFO)
    assert_equal @filename, log.filename
  end
  
  def test_log_errors_for_object
    obj = OpenStruct.new(errors: OpenStruct.new(any?: true, full_messages:["Cannot be blank","Cannot be nil"]))
    log = BearsLogger.initiate_logging(@filename,level:Logger::INFO)
    log.log_errors obj
    flush log
    content = readfile(@filename)
    assert_match(/Cannot be blank/, content)
    assert_match(/Cannot be nil/, content)
    refute_match(/Cannot be empty/, content)
  end
  
  def test_tail
    log = BearsLogger.initiate_logging(@filename,level:Logger::INFO)
    log.info "Info 1"
    log.error "Error 1"
    log.info "Info 2"
    log.error "Error 2"
    flush log
    assert_match(/Info 2/, log.tail(count:2).join())
    assert_match(/Error 2/, log.tail(count:2).join())
    refute_match(/Info 1/, log.tail(count:2).join())
    assert_match(/Error 1/, log.tail(count:3,regexp:/error/i).join())
    refute_match(/Error 1/, log.tail(count:1,regexp:/error/i).join())
  end
end