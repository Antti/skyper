module Skyper
  class Group < SkypeObject
    #TYPE: {ALL | CUSTOM | HARDWIRED | SHARED_GROUP | PROPOSED_SHARED_GROUP}
    property_reader :TYPE, :CUSTOM_GROUP_ID, :NROFUSERS, :NROFUSERS_ONLINE, :USERS
    property_accessor :DISPLAYNAME
    self.object_name = "GROUP"

    class << self
      # Returns hash of symols (group types) => Group objects
      def groups
        r = Skype.send_command "SEARCH GROUPS ALL"
        r.gsub!(/^\D+/, "")
        group_ids = r.split /,\s*/
        group_ids.map do |id|
          Group.new(id)
        end
      end
    end

    # Returns array of skype names of users in this group
    def member_user_names
      r = users
      r && r.sub(/^.*USERS /, "").split(", ") or []
    end

    # Returns array of Users in this Group
    def user_objects
      member_user_names.map { |h| User.new h }
    end
  end
end