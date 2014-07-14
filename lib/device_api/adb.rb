require 'open3'
require 'ostruct'


module DeviceAPI

  # Namespace for all methods encapsulating adb calls
  class ADB

    # Returns a hash representing connected devices
    # DeviceAPI::ADB.devices #=> { '1232132' => 'device' }
    def self.devices
      result = DeviceAPI::ADB.execute( 'adb devices' )
      
      raise result.stderr if result.exit != 0
      
      lines = result.stdout.split("\n")
      
      results = []
      
      # Drop the message line
      lines.shift
      
      lines.each do |l|
        if /(.*)\t(.*)/.match(l)
          results.push( { $1.strip => $2.strip } )
        end
      end
      
      results
    end


    def self.getprop(serial)
      result = DeviceAPI::ADB.execute( "adb -s #{serial} shell getprop" )
      
      raise result.stderr if result.exit != 0
        
      lines = result.stdout.split("\n")
      
      props = {}
      lines.each do |l|
        if /\[(.*)\]:\s+\[(.*)\]/.match(l)
          props[$1] = $2
        end
      end
      props
    end

    def self.getdumpsys(serial)
      result = DeviceAPI::ADB.execute( "adb -s #{serial} shell dumpsys input" )

      raise result.stderr if result.exit != 0

      lines = result.stdout.split("\n").collect{|line| line.strip}

      props = {}
      lines.each do |l|
        if /(.*):\s+(.*)/.match(l)
          props[$1] = $2
        end
      end
      props



    end

    

    # Execute out to shell
    # Returns a struct collecting the execution results
    # struct = DeviceAPI::ADB.execute( 'adb devices' )
    # struct.stdout #=> "std out"
    # struct.stderr #=> ''
    # strict.exit #=> 0
    def self.execute( command )

      result = OpenStruct.new

      stdout, stderr, status = Open3.capture3( command )
      
      result.exit = status.exitstatus
      result.stdout = stdout
      result.stderr = stderr

      result
    end
  end

end


