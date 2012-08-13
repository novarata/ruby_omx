module RubyOmx

  class ItemUpdateResponse < Response
    xml_name "ItemUpdateResponse"
    xml_reader :success
	  xml_reader :errors, :as=>[Error], :in=>'ErrorData'

    def to_s
      error_string = self.errors.collect{ |e| e.message.to_s }.join(',')
      return "success: #{success}, errors: #{error_string}"
    end

  end
    
end