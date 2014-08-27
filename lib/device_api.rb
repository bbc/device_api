require 'device_api/sys_logger'

module DeviceAPI
  attr_accessor :logger

  @@logger = DeviceAPI::SysLogger.new

  def self.set_logger(logger)
    @@logger = logger
  end

  def self.logger
    @@logger
  end
end