require 'device_api/sys_log'

module DeviceAPI
  attr_accessor :log

  @@log = DeviceAPI::SysLog.new

  def self.set_logger(log)
    @@log = log
  end

  def self.log
    @@log
  end
end