module RubyOmx
    
  class UDOAResponse < Response
    xml_name "UDOAResponse"
	 	xml_reader :OMX
	 	xml_reader :order_number, :in => "UDOARequest/Header"
  end
    
end
