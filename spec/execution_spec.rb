$LOAD_PATH.unshift('./lib/')

require 'device_api/execution'

include RSpec

ProcessStatusStub = Struct.new(:exitstatus)
$STATUS_ZERO = ProcessStatusStub.new(0)

describe DeviceAPI::Execution do
  describe '.execute' do

    before(:all) do
      @result = DeviceAPI::Execution.execute('echo boo')
    end

    it 'returns an OpenStruct execution result' do
      expect(@result).to be_a OpenStruct
    end

    it 'captures exit value in hash' do
      expect(@result.exit).to eq(0)
    end

    it 'captures stdout in hash' do
      expect(@result.stdout).to eq("boo\n")
    end

    it 'capture stderr in hash' do
      expect(@result.stderr).to eq('')
    end

  end

  describe '.execute_with_timeout_and_retry' do
    it 'should raise an exception if the command takes too long to execute' do
      stub_const('DeviceAPI::Execution::COMMAND_TIMEOUT',1)
      stub_const('DeviceAPI::Execution::COMMAND_RETRIES',1)
      sleep_time = 5
      cmd = "sleep #{sleep_time.to_s}"
      expect { DeviceAPI::Execution.execute_with_timeout_and_retry(cmd) }.to raise_error(DeviceAPI::CommandTimeoutError)
    end

    it 'should execute successfully if command returns before the timeout' do
      stub_const('DeviceAPI::Execution::COMMAND_TIMEOUT',2)
      stub_const('DeviceAPI::Execution::COMMAND_RETRIES',5)
      sleep_time = 1
      cmd = "sleep #{sleep_time.to_s}"
      DeviceAPI::Execution.execute_with_timeout_and_retry(cmd)
    end

  end

end
