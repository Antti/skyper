module Skyper
  class SMS < SkypeObject
    property_accessor *%w[BODY TYPE REPLY_TO_NUMBER TARGET_NUMBERS]
    property_reader *%w[STATUS FAILUREREASON IS_FAILED_UNSEEN PRICE_CURRENCY TARGET_STATUSES]
    property_reader :TIMESTAMP => Time, :PRICE => Integer, :PRICE_PERICISION => Integer
    self.object_name = "SMS"

    class << self
      # @params [Symbol] type one of following: OUTGOING CONFIRMATION_CODE_REQUEST CONFIRMATION_CODE_SUBMIT
      def create(target, type=:OUTGOING)
        r = Skyper::Skype.send_command("CREATE SMS #{type.to_s.upcase} #{target}") #"SMS 354924 STATUS COMPOSING"
        self.parse_from(r)
      end
    end

    def send_sms
      alter("SEND")
    end

  end
end