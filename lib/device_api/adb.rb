# Encoding: utf-8
# TODO: create new class for aapt that will get the package name from an apk using: JitG
# aapt dump badging packages/bbciplayer-debug.apk

require 'open3'
require 'ostruct'

module DeviceAPI
  # Namespace for all methods encapsulating adb calls
  class ADB
    # Returns a hash representing connected devices
    # DeviceAPI::ADB.devices #=> { '1232132' => 'device' }
    def self.devices
      result = DeviceAPI::ADB.execute('adb devices')

      raise ADBCommandError(result.stderr) if result.exit != 0

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

    def self.getprop(serial)
      result = DeviceAPI::ADB.execute("adb -s #{serial} shell getprop")

      raise ADBCommandError(result.stderr) if result.exit != 0

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
      result = DeviceAPI::ADB.execute("adb -s #{serial} shell dumpsys input")

      raise ADBCommandError(result.stderr) if result.exit != 0

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
      result = DeviceAPI::ADB.execute("adb -s #{serial} install #{apk}")

      raise ADBCommandError(result.stderr) if result.exit != 0

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
      raise ADBCommandError(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n").map { |line| line.strip }

      lines.last
    end

    def self.get_uptime(serial)
      result = DeviceAPI::ADB.execute("adb -s #{serial} shell cat /proc/uptime")

      raise ADBCommandError(result.stderr) if result.exit != 0

      lines = result.stdout.split("\n")

      uptime = 0
      lines.each do |l|
        if /^([\d.]*)\s+[\d.]*$/.match(l)
          uptime = Regexp.last_match[1].to_f.round
        else
          raise ADBCommandError("Invalid uptime for device #{serial}!")
        end
      end
      uptime
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
