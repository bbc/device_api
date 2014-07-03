$LOAD_PATH.unshift( './lib/' )

require 'device_api/device/android'
include RSpec

describe DeviceAPI::Device::Android do
  describe ".model" do
    
    it "Returns model name" do
      device = DeviceAPI::Device::Android.new(:serial => 'SH34RW905290')

      allow(Open3).to receive(:capture3) { [ '[ro.product.model]: [HTC One]\n', '', $STATUS_ZERO] }
      expect(device.model).to eq('HTC One')
    end
  end
end
