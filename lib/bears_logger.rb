require 'logger'

class BearsLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_s} #{severity} #{msg}\n" 
  end
  
  def filename
    @logdev.dev.path
  end
  
  # tails last count lines of the file and returns them
  # if regexp if provided provide only the matching lines in the last count lines
  def tail(opts = {count:100, regexp:nil})
    result = []
    count = opts[:count]
    File::Tail::Logfile.open(filename, :return_if_eof => true, :backward=>count) do |log|
      log.tail { |line| result<<line if line.match(/#{opts[:regexp]}/i) }
    end
    result
  end

  def log_errors(object)
    if object.errors.any?
      self.error "Cannot save:"
      self.error object.inspect
      object.errors.full_messages.each do |msg|
        self.error msg
      end
    end
  end
  
  # class methods
  class << self
    def initiate_logging(file, opts = { sync:true, level: Logger::WARN })
      logfile = File.open(file, 'a')
      logfile.sync = use_sync? opts[:sync]
      logger=BearsLogger.new(logfile)
      logger.level = Rails.env=="production" ? opts[:level] : Logger::DEBUG
      logger
    end
    
    private
      # Return sync flag based on environment, it iwll be always true in dev
      def use_sync?(sync)
        Rails.env == "production" ? sync : true
      end
  end
end