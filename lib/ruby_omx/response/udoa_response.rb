module RubyOmx
    
  class UDOAResponse < Response
    xml_name "UDOAResponse"
	 	xml_reader :success, :as => Integer
	 	xml_reader :OMX
	 	xml_reader :order_number, :in => "UDOARequest/Header"
			xml_accessor :errors, :as=>[Error], :in=>'ErrorData'
  end
    
end
