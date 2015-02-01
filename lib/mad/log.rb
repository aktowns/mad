require 'logger'

# A crazy text editor written in ruby.
module Mad
  def self.debug?
    ENV['DEBUG'] == '1'
  end

  # Simplistic logger, since STDOUT tends to get messy
  class Log
    class << self
      def common
        @logger ||= Logger.new('logfile.log')
      end

      def specific(out)
        @loggers      ||= {}
        @loggers[out] ||= Logger.new(out)
      end
    end
  end
end
