module Skyper
  class ChatMessage < Skyper::SkypeObject
    property_accessor :BODY, :FROM_DISPNAME, :TYPE, :STATUS, :LEAVEREASON, :CHATNAME, :IS_EDITABLE, :EDITED_BY, :EDITED_TIMESTAMP, :OPTIONS, :ROLE
    property_reader :TIMESTAMP => Time, :FROM_HANDLE => Skyper::User, :USERS => Array
    self.object_name = "CHATMESSAGE"
  end
end
