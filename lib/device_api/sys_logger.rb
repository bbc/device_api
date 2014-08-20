
require 'syslog'

module DeviceAPI
  class SysLogger

    attr_accessor :syslog

    def log(priority,message)
      if @syslog and @syslog.opened?
        @syslog = Syslog.reopen('device-api-gem', Syslog::LOG_PID, Syslog::LOG_DAEMON)
      else
        @syslog = Syslog.open('device-api-gem', Syslog::LOG_PID, Syslog::LOG_DAEMON)
      end

      @syslog.log(priority,message)
      @syslog.close
    end

    def log_fatal(message)
      self.log(Syslog::LOG_CRIT,message)
    end

    def log_error(message)
      self.log(Syslog::LOG_ERR,message)
    end

    def log_warn(message)
      self.log(Syslog::LOG_WARNING,message)
    end

    def log_info(message)
      self.log(Syslog::LOG_INFO,message)
    end

    def log_debug(message)
      self.log(Syslog::LOG_DEBUG,message)
    end
  end
end