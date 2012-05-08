require 'appscript'
require 'logger'
require 'singleton'
require 'forwardable'

module Skyper

  # Singleton for interfacing with Skype
  # See https://developer.skype.com/public-api-reference for objects properties
  class Skype
    include Singleton
    attr_accessor :script_name
    attr_reader :connection

    def initialize
      @connection = Skyper::Mac::Connection.new
      send_command("PROTOCOL 8")
    end

    # @param[String] command Skype command
    def send_command(command)
      @connection.send_command(command)
    end

    # @return[Profile] current profile
    def profile
      @profile ||= Profile.new(nil)
    end

    # Initiates a Skype call
	  def call(*users)
      Call.create(*users)
    end

    # Returns an Array of Call IDs if there is an incoming Skype call otherwise nil
    def incoming_calls
      Call.active_calls
    end

    # Answers a call given a skype Call ID.  Returns an Array of Call objects.
    def answer(call)
      cmd = "ALTER CALL #{call.call_id} ANSWER"
      r = Skype.send_command cmd
      raise RuntimeError("Failed to answer call.  Skype returned '#{r}'") unless r == cmd
    end

    # Returns an Array of Group
    def groups
      @groups ||= Group.groups
    end

    # Returns Array of all User in a particular Group type.  Accepts types as defined by Group.types
    def find_users_of_type(group_type)
      groups.find { |g| g.type == group_type}.users
    end

    # Returns an array of users online friends as User objects
    def online_friends
      find_users_of_type "ONLINE_FRIENDS"
    end

    # Array of all User that are friends of the current user
    def all_friends
      find_users_of_type "ALL_FRIENDS"
    end

    # Array of all User defined as Skype Out users
    def skypeout_friends
      find_users_of_type "SKYPEOUT_FRIENDS"
    end

    # Array of all User that the user knows
    def all_users
      find_users_of_type "ALL_USERS"
    end

    # Array of User recently contacted by the user, friends or not
    def recently_contacted_users
      find_users_of_type "RECENTLY_CONTACTED_USERS"
    end

    # Array of User waiting for authorization
    def users_waiting_for_authorization
      find_users_of_type "USERS_WAITING_MY_AUTHORIZATION"
    end

    # Array of User blocked
    def blocked_users
      find_users_of_type "USERS_BLOCKED_BY_ME"
    end
    class << self
       extend Forwardable
       def_delegators :instance, *Skyper::Skype.instance_methods(false)
     end
  end

end
