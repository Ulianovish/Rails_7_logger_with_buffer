module MyReverseLogger
  include ActiveSupport::TaggedLogging

  class << self
    attr_accessor :logger
    delegate :info, :warn, :debug, :error, :to => :logger
  end

  def self.new(logger)
    logger.formatter ||= ActiveSupport::Logger::SimpleFormatter.new
    logger.formatter.extend Formatter
    logger.extend(self)
  end


  module Formatter
    include ActiveSupport::TaggedLogging::Formatter

    def call(severity, timestamp, progname, msg)
      tagged_message = "[#{severity}] #{msg.reverse}"

      self.class.instance_method(:call).bind(self).call(severity, timestamp, progname, tagged_message)
    end
  end
end