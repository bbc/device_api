# Encoding: utf-8
require 'open3'
require 'ostruct'
require 'timeout'
module DeviceAPI
  # Provides method to execute terminal commands in a reusable way
  class Execution

    # execute_with_timeout_and_retry constants
    COMMAND_TIMEOUT = 30 # base number of seconds to wait until adb command times out
    COMMAND_RETRIES = 5 # number of times we will retry the adb command.
    # actual maximum seconds waited before timeout is
    # (1 * s) + (2 * s) + (3 * s) ... up to (n * s)
    # where s = COMMAND_TIMEOUT
    # n = COMMAND_RETRIES

    def self.execute(command)
      # Execute out to shell
      # Returns a struct collecting the execution results
      # struct = DeviceAPI::ADB.execute( 'adb devices' )
      # struct.stdout #=> "std out"
      # struct.stderr #=> ''
      # strict.exit #=> 0
      result = OpenStruct.new

      stdout, stderr, status = Open3.capture3(command)

      result.exit = status.exitstatus
      result.stdout = stdout
      result.stderr = stderr

      result
    end

    def self.execute_with_timeout_and_retry(command)
      retries_left = COMMAND_RETRIES
      cmd_successful = false
      result = 0

      while (retries_left > 0) and (cmd_successful == false) do
        begin
          ::Timeout.timeout(COMMAND_TIMEOUT) do
            result = execute(command)
            cmd_successful = true
          end
        rescue ::Timeout::Error
          retries_left -= 1
          if retries_left > 0
            DeviceAPI.log.error "Command #{command} timed out after #{COMMAND_TIMEOUT.to_s} sec, retrying,"\
                + " #{retries_left.to_s} attempts left.."
          end
        end
      end

      if retries_left < COMMAND_RETRIES # if we had to retry
        if cmd_successful == false
          msg = "Command #{command} timed out after #{COMMAND_RETRIES.to_s} retries. !"\
            + " Exiting.."
          DeviceAPI.log.fatal(msg)
          raise DeviceAPI::CommandTimeoutError.new(msg)
        else
          DeviceAPI.log.info "Command #{command} succeeded execution after retrying"
        end
      end

      result
    end
  end

  class CommandTimeoutError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

end
