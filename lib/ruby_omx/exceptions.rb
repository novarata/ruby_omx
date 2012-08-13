module RubyOmx
    
  # Abstract super class of all RubyOmx exceptions
  class RubyOmxException < StandardError
  end
    
  # Abstract super class for all invalid options.
  class InvalidOption < RubyOmxException
  end
  
  class MissingRequestOptions < RubyOmxException
  end
  
    
  class MissingConnectionOptions < RubyOmxException
  end
        
  class RequestTimeout < ResponseError
  end
    
  # Most ResponseError's are created just time on a need to have basis, but we explicitly define the
  # InternalError exception because we want to explicitly rescue InternalError in some cases.
  class InternalError < ResponseError
  end
    
  # Raised if an unrecognized option is passed when establishing a connection.
  #class InvalidConnectionOption < InvalidOption
  #  def initialize(invalid_options)
  #    message = "The following connection options are invalid: #{invalid_options.join(', ')}. "    +
  #              "The valid connection options are: #{Connection::Options::VALID_OPTIONS.join(', ')}."
  #    super(message)
  #  end
  #end
    
  # Raised if the access key arguments are missing when establishing a connection.
  class MissingAccessKey < InvalidOption
    def initialize(missing_keys)
      key_list = missing_keys.map {|key| key.to_s}.join(' and the ')
      super("You did not provide both required access keys. Please provide the #{key_list}.")
    end
  end
    
  # Raised if a request is attempted before any connections have been established.
  #class NoConnectionEstablished < RubyOmxException
  #  def initialize
  #    super("\nPlease use RubyOmx::Base.establish_connection! before making API calls.")
  #  end
  #end
        
end