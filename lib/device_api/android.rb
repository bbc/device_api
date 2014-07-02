require 'device_api/adb'
require 'device_api/device/android'

module DeviceAPI

  # Namespace for querying connected android devices using ADB
  class Android
    
    # Returns array of connected android devices
    def self.devices
      ADB.devices.collect do |d|
        DeviceAPI::Device::Android.new( :serial => d.keys.first, :state => d.values.first )
      end
    end

  end

end 
