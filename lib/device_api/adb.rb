# Encoding: utf-8
# TODO: create new class for aapt that will get the package name from an apk using: JitG
# aapt dump badging packages/bbciplayer-debug.apk
require 'open3'
require 'ostruct'
require 'device_api/execute_cmd'

module DeviceAPI
  # Namespace for all methods encapsulating adb calls
  class ADB < Execute
    # Returns a hash representing connected devices
    # DeviceAPI::ADB.devices #=> { '1232132' => 'device' }
    def self.devices
      result = DeviceAPI::Execute.execute('adb devices')

      raise ADBCommandError.new(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n")
      results = []

      lines.shift # Drop the message line
      lines.each do |l|
        if /(.*)\t(.*)/.match(l)
          results.push(Regexp.last_match[1].strip => Regexp.last_match[2].strip)
        end
      end
      results
    end
    
    # Retrieve device state for a single device
    def self.get_state(serial)
      result = DeviceAPI::ADB.execute('adb get-state -s #{serial}')

      raise ADBCommandError.new(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n")
      /(.*)/.match(lines.last)
      Regexp.last_match[0].strip
    end
    

    def self.getprop(serial)
      result = DeviceAPI::Execute.execute("adb -s #{serial} shell getprop")

      raise ADBCommandError.new(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n")

      props = {}
      lines.each do |l|
        if /\[(.*)\]:\s+\[(.*)\]/.match(l)
          props[Regexp.last_match[1]] = Regexp.last_match[2]
        end
      end
      props
    end

    def self.getdumpsys(serial)
      result = DeviceAPI::Execute.execute("adb -s #{serial} shell dumpsys input")

      raise ADBCommandError.new(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n").map { |line| line.strip }

      props = {}
      lines.each do |l|
        if /(.*):\s+(.*)/.match(l)
          props[Regexp.last_match[1]] = Regexp.last_match[2]
        end
      end
      props
    end

    def self.install_apk(options = {})
      apk = options[:apk]
      serial = options[:serial]
      result = DeviceAPI::Execute.execute("adb -s #{serial} install #{apk}")

      raise ADBCommandError.new(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n").map { |line| line.strip }
      # lines.each do |line|
      #  res=:success if line=='Success'
      # end

      lines.last
    end

    def self.uninstall_apk(options = {})
      package_name = options[:package_name]
      serial = options[:serial]
      result = DeviceAPI::ADB.execute("adb -s #{serial} uninstall #{package_name}")
      raise ADBCommandError.new(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n").map { |line| line.strip }

      lines.last
    end

    def self.get_uptime(serial)
      result = DeviceAPI::ADB.execute("adb -s #{serial} shell cat /proc/uptime")

      raise ADBCommandError.new(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n")
      uptime = 0
      lines.each do |l|
        if /([\d.]*)\s+[\d.]*/.match(l)
          uptime = Regexp.last_match[0].to_f.round
        end
      end
      uptime
    end

    def self.reboot(serial)
      result = DeviceAPI::ADB.execute("adb -s #{serial} reboot")
      raise ADBCommandError.new(result.stderr) if result.exit != 0
    end
    
        # Retrieve device state for a single device
    def self.monkey(serial, args)
      
      events = args[:events] || 10000
      package = args[:package] or raise "package name not provided (:package => 'bbc.iplayer')"
      seed = args[:seed]
      throttle = args[:throttle]
      
      cmd = "adb -s #{serial} shell monkey -p #{package} -v #{events}"
      cmd = cmd + " -s #{seed}" if seed
      cmd = cmd + " -t #{throttle}" if throttle
      
      result = DeviceAPI::ADB.execute( cmd )
    end

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

    class ADBCommandError < StandardError
      def initialize(msg)
        super(msg)
      end
    end

  end
end
