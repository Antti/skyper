module Skyper
  # You need to start skype with following keys: --enable-dbus --use-system-dbus
  module Linux
    # Service is com.Skype.API
    # Communication paths:
    # The client-to-Skype path is /com/Skype.
    # The Skype-to-client path is /com/Skype/Client.


    # Use the Invoke method with one string parameter for client-to-Skype commands.
    # Use the Notify method for Skype-to-client commands and responses.
    # D-BUS is disabled by default.
    class Connection
      attr_accessor :logger
      attr_reader :options

      def initialize(options={})
        @options = options
        @logger ||= Logger.new(STDOUT).tap do |logger|
          logger.level = Logger::ERROR
        end
        require 'dbus'
        @session_bus = DBus::SessionBus.instance
        @ruby_srv = @session_bus.service("com.Skype.API")
        @client = @ruby_srv.object("/com/Skype/Client")
        @skype = @ruby_srv.object("/com/Skype")
        @client.on_signal("Notify") do |u, v|
          puts "SomethingJustHappened: #{u} #{v}"
        end
        answer = @skype.send_command("NAME skyper")
        @skype.send_command("PROTOCOL 7")
        main = DBus::Main.new
        main << session_bus
        main.run
      end

      # @param[String] command Skype command
      def send_command(command)
        logger.debug "#{self.class}##{__method__} sending: #{command}"
        response = @skype.Invoke command
        response.tap do
          logger.debug "#{self.class}##{__method__} response: #{response}"
        end
      end

    end
  end
end