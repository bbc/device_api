device_api
==========

OO Device management abstraction


Quick Setup
===========


require 'device_api/android'

devices = DeviceAPI::Android.devices

device.first                # <DeviceAPI::Device::Android:0x007f8b8c292a88 @serial="01498A0004005015", @state="device">
device.first.serial         #  "01498A0004005015"
device.first.model          #  "Galaxy Nexus"

device.first.orientation    # :landscape / :portrait

