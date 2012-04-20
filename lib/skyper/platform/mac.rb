module Skyper
  module Mac
    class Connection
      attr_accessor :logger
      attr_reader :options

      def initialize(options={})
        @options = options
        @logger ||= Logger.new(STDOUT).tap do |logger|
          logger.level = Logger::ERROR
        end
      end

      # @param[String] command Skype command
      def send_command(command)
        params = {:script_name => options[:script_name].to_s, :command => command}
        logger.debug "#{self.class}##{__method__} params: #{params.inspect}"
        response = Appscript::app('Skype').send_ params
        response.tap do
          logger.debug "#{self.class}##{__method__} response: #{response}"
        end
      end

    end
  end
end
