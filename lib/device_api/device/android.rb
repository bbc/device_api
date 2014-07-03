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
      get_prop('ro.product.model')
    end
    
    
 
 
    private
    
    def get_prop( key )
      if !@props || !@props[key]
        @props = ADB.getprop( serial )
      end
      @props[key]
    end

  end
end
