module RubyOmx

  class ErrorMessage < Response
    xml_name "Error"
    xml_reader :message, :in => "Error", :from => :content
  end

  class ResponseError < Response
    xml_name "ErrorResponse"
      
    #xml_reader :type, :in => "Error"
    #xml_reader :code, :in => "Error"    
    #xml_reader :message, :in => "Error"    
    #xml_reader :detail, :in => "Error"
    #xml_reader :request_id
    xml_reader :success
    xml_reader :errors, :as=>[ErrorMessage]

    def to_s
      self.errors.join(',')
    end

  end
   
end