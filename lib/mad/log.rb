require 'logger'

module Mad
  def self.debug?
    ENV['DEBUG'] == '1'
  end

  class Log
    class << self
      def common
        @@logger ||= Logger.new('logfile.log')
      end

      def specific(out)
        @@loggers      ||= {}
        @@loggers[out] ||= Logger.new(out)
      end
    end
  end
end
