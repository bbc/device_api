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

  describe ".orinetation" do
    it "Returns portrait when device is portrait" do
      device = DeviceAPI::Device::Android.new(:serial => 'SH34RW905290')
      allow(Open3).to receive(:capture3) { [ "SurfaceOrientation: 0\r\n", '', $STATUS_ZERO] }

      expect(device.orientation).
          to eq(:portrait)
    end

    it "Returns landscape when device is landscape" do
      device = DeviceAPI::Device::Android.new(:serial => 'SH34RW905290')
      allow(Open3).to receive(:capture3) { [ "SurfaceOrientation: 1\r\n", '', $STATUS_ZERO] }

      expect(device.orientation).
          to eq(:landscape)
    end

    it "Returns an error if response not understood" do
      device = DeviceAPI::Device::Android.new(:serial => 'SH34RW905290')

      allow(Open3).to receive(:capture3) { [ "SurfaceOrientation: 564654654\n", '', $STATUS_ZERO] }

      expect{device.orientation}.
        to raise_error(StandardError, 'Device orientation not returned got: 564654654.')
    end

    it "Returns an error if no device found" do
      device = DeviceAPI::Device::Android.new(:serial => 'SH34RW905290')

      allow(Open3).to receive(:capture3) { [ "error: device not found\n", '', $STATUS_ZERO] }

      expect{device.orientation}.
          to raise_error(StandardError, 'No output returned is there a deivce connected?')
    end

    it 'Can filter on large amounts of adb output to find the correct value',:type=>'adb' do
      out = <<_______________________________________________________
uchMajor: min=0, max=15, flat=0, fuzz=0, resolution=0\r\n        TouchMinor: unknown range\r\n
ToolMajor: unknown range\r\n        ToolMinor: unknown range\r\n        Orientation: unknown range\r\n
Distance: unknown range\r\n        TiltX: unknown range\r\n        TiltY: unknown range\r\n
TrackingId: min=0, max=65535, flat=0, fuzz=0, resolution=0\r\n        Slot: min=0, max=9, flat=0, fuzz=0,
resolution=0\r\n      Calibration:\r\n        touch.size.calibration: diameter\r\n
touch.size.scale: 22.500\r\n        touch.size.bias: 0.000\r\n        touch.size.isSummed: false\r\n
touch.pressure.calibration: amplitude\r\n        touch.pressure.scale: 0.013\r\n        touch.orientation.calibration: none\r\n
 touch.distance.calibration: none\r\n        touch.coverage.calibration: none\r\n      Viewport: displayId=0, orientation=0,
logicalFrame=[0, 0, 768, 1280], physicalFrame=[0, 0, 768, 1280], deviceSize=[768, 1280]\r\n      SurfaceWidth: 768px\r\n
 SurfaceHeight: 1280px\r\n      SurfaceLeft: 0\r\n      SurfaceTop: 0\r\n      SurfaceOrientation: 0\r\n
 Translation and Scaling Factors:\r\n        XTranslate: 0.000\r\n        YTranslate: 0.000\r\n        XScale: 0.500\r\n
     YScale: 0.500\r\n        XPrecision: 2.000\r\n        YPrecision: 2.000\r\n
_______________________________________________________
      device = DeviceAPI::Device::Android.new(:serial => 'SH34RW905290')
      allow(Open3).to receive(:capture3) { [out, '', $STATUS_ZERO] }

      expect(device.orientation).
          to eq(:portrait)

    end

  end

end
