module RubyOmx
    
  class UDOAResponse < StandardResponse
    xml_name "UDOAResponse"
	 	xml_reader :OMX
	 	xml_reader :order_number, :in => "UDOARequest/Header"
  end
    
end
