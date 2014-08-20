# Encoding: utf-8
require 'open3'
require 'ostruct'
module DeviceAPI
  # Provides method to execute terminal commands in a reusable way
  class Execute
    # Execute out to shell
    # Returns a struct collecting the execution results
    # struct = DeviceAPI::ADB.execute( 'adb devices' )
    # struct.stdout #=> "std out"
    # struct.stderr #=> ''
    # strict.exit #=> 0
    def self.execute(command)
      result = OpenStruct.new

      stdout, stderr, status = Open3.capture3(command)

      result.exit = status.exitstatus
      result.stdout = stdout
      result.stderr = stderr

      result
    end
  end
end
