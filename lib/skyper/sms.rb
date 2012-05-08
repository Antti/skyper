module Skyper
  # Represents Skype SMS Object
  # @example Send SMS
  #   sms = Skyper::SMS.create("+3809901234567") # => "SMS 354924 STATUS COMPOSING"
  #   sms.body = "Hello, testing SMS feature" # => "Hello, testing SMS feature"
  #   sms.send_sms
  #
  # @example You can inspect SMS price:
  #   sms.price # => 66
  #
  # The price is displayed with #price_precision.
  # After sending sms, you can check it's status using:
  # @example
  #   sms.status # => "SENT_TO_SERVER"
  #   # in 3 sec.
  #   sms.status # => "DELIVERED"
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