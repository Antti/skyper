module Skyper

  # Singleton for managing Skype user status
  class Iam
    @@STATUSES = [:ONLINE, :OFFLINE, :SKYPEME, :AWAY, :NA, :DND, :INVISIBLE]

    def self.user_status=(status)
      raise NoMethodError.new("#{status} in #{Iam.to_s}") if not @@STATUSES.index status.upcase.to_sym
      Skype.send_command "SET USERSTATUS #{status}"
    end

    # Handles all of the user status permutations accepted by Skype otherwise Errors.
    # For example, <i>Iam.away</i> is legal.
    def self.method_missing(id)
      self.user_status = id.id2name
    end
  end
end