# Encoding: utf-8
require 'device_api/device'
require 'device_api/adb'

module DeviceAPI
  class Device::Android < Device
    def initialize(options = {})
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
      res = get_dumpsys('SurfaceOrientation')

      case res
      when '0'
        :portrait
      when '1'
        :landscape
      when nil
        fail StandardError, 'No output returned is there a device connected?', caller
      else
        fail StandardError, "Device orientation not returned got: #{res}.", caller
      end
    end

    def install(apk)
      fail StandardError, 'No apk specified.', caller if apk.empty?
      res = install_apk(apk)

      case res
      when 'Success'
        :success
      else
        fail StandardError, res, caller
      end
    end

    def uninstall(package_name)
      res = uninstall_apk(package_name)
      case res
      when 'Success'
        :success
      else
        fail StandardError, "Unable to install 'package_name' Error Reported: #{res}", caller
      end
    end

    private

    def get_prop(key)
      if !@props || !@props[key]
        @props = ADB.getprop(serial)
      end
      @props[key]
    end

    def get_dumpsys(key)
      @props = ADB.getdumpsys(serial)
      @props[key]
    end

    def install_apk(apk)
      ADB.install_apk(apk: apk, serial: serial)
    end

    def uninstall_apk(package_name)
      ADB.uninstall_apk(package_name: package_name, serial: serial)
    end
  end
end
