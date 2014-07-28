device_api
==========

OO Device management abstraction


Quick Setup
===========


Initialise
---------
require 'device_api/android'
device = DeviceAPI::Android.devices


Device info
-----------
device.first                # <DeviceAPI::Device::Android:0x007f8b8c292a88 @serial="01498A0004005015", @state="device">
device.first.serial         #  "01498A0004005015"
device.first.model          #  "Galaxy Nexus"

Device orientation
------------------
device.first.orientation    # :landscape / :portrait

Install/uninstall apk
---------------------
device.first.install('location/apk_to_install.apk') # will install the apk on the first device
device.first.uninstall('fake.package.name') # will uninstall the package from the device


