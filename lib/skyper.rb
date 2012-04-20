$:.unshift File.expand_path('../',__FILE__)
module Skyper
  autoload :SkypeObject, 'skyper/skype_object'
  autoload :User, 'skyper/user'
  autoload :Chat, 'skyper/chat'
  autoload :Group, 'skyper/group'
end
Dir[File.join(File.dirname(__FILE__), 'skyper/**/*.rb')].sort.each { |lib| require lib }
