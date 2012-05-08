module Skyper
  class Chat < SkypeObject
    # @!attribute [rw] name Chat name
    # @!attribute [rw] timestamp Timestamp
    # @!attribute [rw] posters List of users who can write to this chat
    # @!attribute [rw] topic Chat topic
    # @!attribute [rw] topicxml XML topic
    # @!attribute [rw] activemembers List of chat active members
    # @!attribute [rw] friendlyname Friendlyname
    # @!attribute [rw] bookmarked If chat is bookmarked
    # @!attribute [rw] memberobjects
    # @!attribute [rw] passwordhint
    # @!attribute [rw] guidelines
    # @!attribute [rw] options
    property_accessor *%w[NAME TIMESTAMP ADDER POSTERS TOPIC TOPICXML ACTIVEMEMBERS FRIENDLYNAME BOOKMARKED MEMBEROBJECTS PASSWORDHINT GUIDELINES
    OPTIONS DESCRIPTION DIALOG_PARTNER ACTIVITY_TIMESTAMP TYPE MYSTATUS MYROLE BLOB APPLICANTS]
    property_reader :RECENTCHATMESSAGES => Array
    property_reader :STATUS, :MEMBERS, :CHATMESSAGES
    self.object_name = "CHAT"
    attr_reader :id

    class << self
      # create by user_handle
      # @param [User|String]
      def create(user_handle)
        r = Skype.send_command "CHAT CREATE #{user_handle}"
        Chat.parse_from r
      end

      # Returns an array of your Skype recent chats
      def recent_chats
        r = Skype.send_command "SEARCH RECENTCHATS"
        chat_ids = parse_type(r.sub(/^CHATS\s+/, ""), Array)
        chat_ids.map do |id|
          Chat.new(id)
        end
      end
    end

    # chat message to chat
    def chat_message(message)
      r = Skype.send_command "CHATMESSAGE #{id} #{message}"
      ChatMessage.parse_from(r)
    end

    def recent_chat_messages
      self.recentchatmessages.map {|id| ChatMessage.new(id)}
    end

    def set_topic(topic)
      alter('SETTOPIC', topic)
    end

  end
end
