# Encoding: utf-8
# TODO: create new class for aapt that will get the package name from an apk using: JitG
# aapt dump badging packages/bbciplayer-debug.apk
require 'pry'
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

      fail result.stderr if result.exit != 0

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
      result = DeviceAPI::Execute.execute("adb -s #{serial} shell getprop")

      fail result.stderr, caller if result.exit != 0

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

      fail result.stderr, caller  if result.exit != 0

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

      fail result.stderr, caller if result.exit != 0

      lines = result.stdout.split("\n").map { |line| line.strip }
      # lines.each do |line|
      #  res=:success if line=='Success'
      # end

      lines.last
    end

    def self.uninstall_apk(options = {})
      package_name = options[:package_name]
      serial = options[:serial]
      result = DeviceAPI::Execute.execute("adb -s #{serial} uninstall #{package_name}")
      fail result.stderr if result.exit != 0

      lines = result.stdout.split("\n").map { |line| line.strip }
      # lines.each do |line|
      #  res=:success if line=='Success'
      # end

      lines.last
    end
  end
end
