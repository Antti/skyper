module Skyper
  # Represents a Skype call.  Developer is responsible for calling Call#hangup at the end of each call, whether it was placed
  # by the caller or is an answered call.
  class Call < SkypeObject
    property_reader :TIMESTAMP => Time, :PARTNER_HANDLE => Skyper::User, :RATE => Integer

    property_reader *%w[PARTNER_DISPNAME TARGET_IDENTITY CONF_ID TYPE STATUS VIDEO_STATUS VIDEO_SEND_STATUS FAILUREREASON SUBJECT
    PSTN_NUMBER DURATION PSTN_STATUS CONF_PARTICIPANTS_COUNT VM_DURATION VM_ALLOWED_DURATION RATE_CURRENCY RATE_PRECISION INPUT OUTPUT CAPTURE_MIC VAA_INPUT_STATUS
    FORWARDED_BY TRANSFER_ACTIVE TRANSFER_STATUS TRANSFERRED_BY TRANSFERRED_TO]

    self.object_name = "CALL"
    class << self
      def active_call_ids
        r = Skype.send_command "SEARCH ACTIVECALLS"
        r.gsub(/CALLS /, "").split(", ")
      end

      def active_calls
        Call.active_call_ids.map { |id| Call.new id unless id == "COMMAND_PENDING"}
      end

      def create(*users)
        user_handles = users.map { |u| (u.is_a? User) ? u.handle : u }
        status = Skype.send_command "CALL #{user_handles.join(', ')}"
        if status =~ /CALL (\d+) STATUS/
          call = Call.new($1)
        else
          raise RuntimeError.new("Call failed. Skype returned '#{status}'")
        end
      end
    end

    # Attempts to hang up a call. <b>Note</b>: If Skype hangs while placing the call, this method could hang indefinitely.
    # <u>Use Skype#Call instead of this method unless you like memory leaks</u>.
    # Raises SkypeError if an error is reported from the Skype API
    def hangup
      self.status = "FINISHED"
    end

    def send_video(toggle_flag)
      alter("#{bool_to_flag(toggle_flag)}_VIDEO_SEND")
    end

    def rcv_video(toggle_flag)
      alter("#{bool_to_flag(toggle_flag)}_VIDEO_RECEIVE")
    end
    protected
    def bool_to_flag(bool)
      bool ? "START" : "STOP"
    end
  end
end
