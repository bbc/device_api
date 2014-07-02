require 'device_api/device'
require 'device_api/adb'

module DeviceAPI
  class Device::Android < Device
    
    def initialize( options = {} )
      @serial = options[:serial]
      @state = options[:state]
    end
    
    def status
      {
        'device'    => :ok,
        'no device' => :dead,
        'offline'   => :offline
        }[@state]
    end
    
    def model
      if !@model
        @model = ADB.model(serial)
      end
      @model
    end

  end
end
