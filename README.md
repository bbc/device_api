# DeviceAPI

*DeviceAPI* is a collection of gems that make working with physical devices easy
and consistent. *DeviceAPI* provides common utilities such as device detection
and identification, and useful helpers for installing applications and
identifying problems with devices.

We use *DeviceAPI* heavily to leverage devices in *Hive CI*. It’s also used by
our test developers in their test code. It’s our interface to the devices we
test against and is where we put all common code for interacting with our
physical devices. It also provides an abstraction so we can deal with devices
interchangeably.

This is the base gem on which all *DeviceAPI* gems are built. It contains the
common execution and logging methods, and the base Device class.

## Testing

Tests are written in rspec, you can run them with:

    bundle install
    bundle exec rspec

## Creating a new DeviceAPI Gem

*DeviceAPI* gems should take a consistent approach to their api where possible.

A new *DeviceApi* gem should, as a minimum, include a detection method on the
class. For example, a DeviceAPI implementation for TVs:

    DeviceAPI::TV.devices
    
... should return an array of device objects of type DeviceAPI::TV.

You should consider adding a way to directly detect a specific device, for
example using the serial:

    DeviceAPI::TV.device( serial_id )

The device object should contain all accessors to the physical device
information:

    device.class  #=> DeviceAPI::TV
    device.model  #=> 'sony'
    device.serial # => 'a221s3144cc23'
    
And also expose functionality through the same object:

    device.reboot()

## License

*DeviceAPI* is available to everyone under the terms of the MIT open source
licence. Take a look at the LICENSE file in the code.

Copyright (c) 2015 BBC
