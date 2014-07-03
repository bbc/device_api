$LOAD_PATH.unshift( './lib/' )

require 'device_api/adb'

include RSpec

ProcessStatusStub = Struct.new(:exitstatus)
$STATUS_ZERO = ProcessStatusStub.new(0)

describe DeviceAPI::ADB do
  describe ".execute" do

    before(:all) do
      @result = DeviceAPI::ADB.execute('echo boo')
    end

    it "returns an OpenStruct execution result" do
      expect( @result ).to be_a OpenStruct
    end
    
    it "captures exit value in hash" do
      expect( @result.exit ).to eq(0)
    end
    
    it "captures stdout in hash" do
      expect( @result.stdout ).to eq( "boo\n" )
    end
    
    it "capture stderr in hash" do
      expect( @result.stderr ).to eq( "" )
    end
    
  end
  
  describe ".devices" do



    
    it "returns an empty array when there are no devices" do
      out = <<eos
List of devices attached


eos
      allow(Open3).to receive(:capture3) {
        [out, '', $STATUS_ZERO]
      }
      expect( DeviceAPI::ADB.devices ).to eq( [] )
    end




    it "returns an array with a single item when there's one device attached" do
      out = <<_______________________________________________________
List of devices attached
SH34RW905290	device

_______________________________________________________
      allow(Open3).to receive(:capture3) { [out, '', $STATUS_ZERO] }
      expect( DeviceAPI::ADB.devices ).to eq( [{ 'SH34RW905290' => 'device' }] )
    end
    
    
    
    
    it "returns an an array with multiple items when there are multiple items attached" do
      out = <<_______________________________________________________
List of devices attached
SH34RW905290	device
123456324	no device

_______________________________________________________
      allow(Open3).to receive(:capture3) { [out, '', $STATUS_ZERO] }
      expect( DeviceAPI::ADB.devices ).to eq( [{ 'SH34RW905290' => 'device' }, { '123456324' => 'no device' }] )
    end
    
    
    
    
    
    it "can deal with extra output when adb starts up" do
      out = <<_______________________________________________________
* daemon not running. starting it now on port 5037 *
* daemon started successfully *
List of devices attached
SH34RW905290	device
_______________________________________________________
      allow(Open3).to receive(:capture3) { [ out, '', $STATUS_ZERO] }
      expect( DeviceAPI::ADB.devices ).to eq( [{ 'SH34RW905290' => 'device' }] )
    end

    
    
  end
  
  describe ".getprop" do
    
    it "Returns a hash of name value pair properties" do
      out = <<________________________________________________________
[net.hostname]: [android-f1e4efe3286b0785]
[dhcp.wlan0.ipaddress]: [10.0.1.34]
[ro.build.version.release]: [4.1.2]
[ro.build.version.sdk]: [16]
[ro.product.bluetooth]: [4.0]
[ro.product.device]: [m7]
[ro.product.display_resolution]: [4.7 inch 1080p resolution]
[ro.product.manufacturer]: [HTC]
[ro.product.model]: [HTC One]
[ro.product.name]: [m7]
[ro.product.processor]: [Quadcore]
[ro.product.ram]: [2GB]
[ro.product.version]: [1.28.161.7]
[ro.product.wifi]: [802.11 a/b/g/n/ac]
[ro.revision]: [3]
[ro.serialno]: [SH34RW905290]
[ro.sf.lcd_density]: [480]
________________________________________________________

      allow(Open3).to receive(:capture3) { [ out, '', $STATUS_ZERO] }
    
      props = DeviceAPI::ADB.getprop('SH34RW905290')

      expect( props ).to be_a Hash
      expect( props['ro.product.model']).to eq('HTC One')
    end
    
    
  
  
  end
  
end

