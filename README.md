# Skyper

A ruby gem, implementing Skype public API.
https://developer.skype.com/public-api-reference

Currently works only on MacOS X, using AppleScript to connect to Skype.
Inspired by rb-skypemac.


## Installation

Add this line to your application's Gemfile:

    gem 'skyper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skyper

## Usage

Send a message to the most recent chat:

	# Get latest active chat
	chat = Skyper::Chat.recent_chats.first
	# Send a message to this chat
	message = chat.chat.chat_message("Hello there")
	# message is a Message object.
	message.body
	=> "Hello there"
	message.body = "Bye"
	=> "Bye"

Send sms:

    sms = Skyper::SMS.create("+3809901234567") # => "SMS 354924 STATUS COMPOSING"
    sms.body = "Hello from Skype" # => "Hello from Skype"
    sms.send_sms


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
