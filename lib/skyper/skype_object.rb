module Skyper
  # Represents skype object with id and properties, such as:
  # USER, PROFILE, CALL, CHATMESSAGE, CHAT, etc.
  # see: https://developer.skype.com/public-api-reference#OBJECTS
  class SkypeObject
    attr_reader :id

    # @param[Object] id Integer or String
    def initialize(id)
      @id = id
    end

    # Invokes GET command for a given object, with id and property
    # @param[String] property Property to retreive
    def get_property(property)
      cmd = ["GET", self.class.object_name, id, property].compact.join(" ")
      response = Skyper::Skype.send_command(cmd)
      raise Skyper::SkypeError, response if response =~ /ERROR/
      reply = %r/(#{self.class.object_name})\s+([\S]+)?\s*(#{property})\s+(.*)/.match(response)
      reply && reply[4]
    end

    # Invokes SET command for a given object with id, property and value
    # @param[String] property Property to be set
    # @param[String] value Property value
    def set_property(property, value)
      cmd = ["SET",self.class.object_name, id, property, value].compact.join(" ")
      Skyper::Skype.send_command(cmd)
    end

    # Invokes ALTER command for an object
    # @param[String] command Command to be sent
    # @param[String] args (optional) Arguments for a command
    # @example usage:
    #   sms = Skyper::SMS.create("+380998887766")
    #   sms.body = "Test"
    #   sms.alter("SEND")
    def alter(command, args=nil)
      cmd = "#{command} #{args}".strip
      Skyper::Skype.send_command("ALTER #{self.class.object_name} #{id} #{cmd}")
    end

    def ==(other)
      @id == other.id
    end

    class << self

      # Defines Skype object name.
      # see https://developer.skype.com/public-api-reference#OBJECTS
      # @param[String] name Object name, usually in UPCASE
      def object_name=(name)
        @object_name = name
      end

      # Returns object name, which class represents
      # @return[String] object_name
      def object_name
        @object_name
      end

      # Defines rw property for an object
      # @param[Symbol,..] props Properties
      def property_accessor(*props)
        property_reader(*props)
        property_writer(*props)
      end

      # Defines write-only property for an object
      def property_writer(*props)
        opts = extract_options!(props)
        opts.each do |prop,type|
          define_method(:"#{prop.downcase}=") do |value|
            set_property(prop, value)
          end
        end
      end
      # Defines read-only property for an object
      def property_reader(*props)
        opts = extract_options!(props)
        opts.each do |prop,type|
          define_method(prop.downcase) do
            self.class.parse_type get_property(prop), type
          end
        end
      end

      # Parses object_id from a response and creates a new object with that ID.
      # @param[String] response Response from Skype
      # @example usage:
      #   Skyper::SMS.parse_from 'SMS 3025 STATUS COMPOSING'
      #   => #<Skyper::SMS:0x007ff24b1194b0 @id=3025>
      def parse_from(response)
        match_data = response.match %r/^#{@object_name} ([^\ ]+)/
        raise SkypeError, "Can not parse response: '#{response}'" unless match_data
        self.new(match_data[1])
      end

      def parse_type(value, type)
        return value unless value && type
        return type.call(value) if type.is_a? Proc
        case type.to_s
        when "Integer" || "Fixnum"
          value.to_i
        when "Array"
          value.split(/,\s*/)
        when "Time"
          Time.at(value.to_i)
        when "bool"
          value == "TRUE"
        else
          if type.superclass == Skyper::SkypeObject
            type.new(value)
          else
            value
          end
        end
      end

      protected
      def extract_options!(array)
        opts = if array.last.is_a? Hash
          array.pop
        else
          {}
        end
        opts.merge! Hash[array.zip(Array.new(array.size))]
      end

    end # class << self

  end
end