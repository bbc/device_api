require 'device_api/device'
require 'device_api/adb'
require 'pry'

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

    def orientation
      res=get_dumpsys('SurfaceOrientation')

      case res
        when "0"
          :portrait
        when "1"
          :landscape
        when nil
          raise StandardError.new "No output returned is there a deivce connected?"
        else
          raise StandardError.new "Device orientation not returned got: #{res}."
      end

    end
    
    
 
 
    private
    
    def get_prop( key )
      if !@props || !@props[key]
        @props = ADB.getprop( serial )
      end
      @props[key]
    end

    def get_dumpsys(key)
      if !@props || !@props[key]
        @props =ADB.getdumpsys(serial)
      end
      @props[key]
    end

  end
end
