require 'my_custom_logger'
require 'my_reverse_logger'
MyCustomLogger.logger = MyCustomLogger.new(Logger.new(STDOUT))
MyReverseLogger.logger = MyReverseLogger.new(Logger.new(STDOUT))