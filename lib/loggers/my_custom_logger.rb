
module MyCustomLogger
  @@buffer = []
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

  def self.setBuffer(value)
    @@buffer << value
  end

  def self.buffer
    @@buffer
  end

  module_function
  def warn_size; @warn_size end
  def warn_size= v;@warn_size = v end
  def error_size; @error_size end
  def error_size= v;@error_size = v end

  module Formatter
    include ActiveSupport::TaggedLogging::Formatter

    def call(severity, timestamp, progname, msg)
      return if MyCustomLogger.is_warn_size(severity, msg)
      return if MyCustomLogger.is_error_size(severity, msg)
      tagged_message = "[#{severity}] #{msg}"

      self.class.instance_method(:call).bind(self).call(severity, timestamp, progname, tagged_message)
    end
  end

  def self.is_warn_size(severity, msg)
    if severity == 'WARN' and !!MyCustomLogger.warn_size and MyCustomLogger.buffer.select { |log| log[:severity] == severity }.size < MyCustomLogger.warn_size then
      MyCustomLogger.buffer << {severity: severity, msg: msg}
      if MyCustomLogger.buffer.select { |log| log[:severity] == severity }.size == MyCustomLogger.warn_size
        MyCustomLogger.buffer.each do |log|
          if log[:severity] == severity
            logger = MyCustomLogger.logger
            logger.warn(log[:msg])
          end
        end
        MyCustomLogger.buffer.delete_if { |log| log[:severity] == severity }
        return true
      else
        return true
      end
    end
    return false
  end

  def self.is_error_size(severity, msg)
    if severity == 'ERROR' and !!MyCustomLogger.error_size and MyCustomLogger.buffer.select { |log| log[:severity] == severity }.size < MyCustomLogger.error_size then
      # MyCustomLogger.buffer << {severity: severity, timestamp: timestamp, progname: progname, msg: msg}
      MyCustomLogger.buffer << {severity: severity, msg: msg}
      if MyCustomLogger.buffer.select { |log| log[:severity] == severity }.size == MyCustomLogger.error_size
        MyCustomLogger.buffer.collect do |log|
          if log[:severity] == severity
            logger = MyCustomLogger.logger
            logger.error(log[:msg])
          end
        end
        MyCustomLogger.buffer.delete_if { |log| log[:severity] == severity }
        return true
      else
        return true
      end
    end
    return false
  end
end