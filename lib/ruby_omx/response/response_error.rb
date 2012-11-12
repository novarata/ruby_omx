module RubyOmx

  class ErrorMessage < Response
    xml_name "Error"
    xml_reader :message, :in => "Error", :from => :content
  end

  class ResponseError < Response
    xml_name "ErrorResponse"
    xml_reader :success
    xml_reader :error_messages, :as=>[ErrorMessage], :in=>'ErrorData'
    
    def to_s
      error_string = self.errors ? self.errors.collect{ |e| e.message.to_s }.join(',') : "none"
      return "Errors: #{error_string}"
    end

  end
   
end