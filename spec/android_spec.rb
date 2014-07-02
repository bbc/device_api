$LOAD_PATH.unshift( './lib/' )

require 'device_api/android'
include RSpec

describe DeviceAPI::Android do
  describe ".devices" do
    
    
    
    it "Returns an empty array when no devices are connected" do
      expect(DeviceAPI::Android.devices).to eq( [] )
    end
    
    
    
    
    
    it "returns an array with a single item when there's one device attached" do
            out = <<_______________________________________________________
List of devices attached
SH34RW905290	device

_______________________________________________________
      allow(Open3).to receive(:capture3) { [out, '', $STATUS_ZERO] }
      
      expect( DeviceAPI::Android.devices[0] ).to be_a DeviceAPI::Device::Android
    end
    
  end
end
