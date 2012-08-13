module RubyOmx

  # ErrorData appears in responses
  class Error < Node
    xml_name 'Error'
    xml_accessor :error_id, :from=>'@errorID'
    xml_accessor :error_severity, :from=>'@errorSeverity'
    xml_accessor :error_detail_0, :from=>'@errorDetail0'
    xml_accessor :error_detail_1, :from=>'@errorDetail1'
    xml_accessor :message, :from=>:content
    
    def to_s
      "#{error_id}: #{error_severity} #{error_detail_0} #{error_detail_1} #{message}"
    end
  end

  class Response < Node
    include ROXML
    xml_convention :camelcase
    
    # This is the factoryish method that is called!, not new
    def self.format(response)
      if response.content_type =~ /xml/ || response.body =~ /<?xml/
        parse_xml(response)  
      else
        response.body
      end
    end
      
    def self.parse_xml(response)
      if [Net::HTTPClientError, Net::HTTPServerError].any? {|error| response.is_a? error }
        puts "ERROR: #{response} -- #{response.body}"
        return ResponseError.from_xml(response.body)
      else
        return self.from_xml(response.body)
      end
    end
  end

  # LineItems appear in requests and responses
  class LineItem < Node
    xml_name "LineItem"
    xml_accessor :line_number, :from => '@lineNumber'
    xml_accessor :item_code
    xml_accessor :quantity, :as => Integer
    xml_accessor :unit_price, :as => Float
    xml_accessor :price, :as => Float
    xml_accessor :update_standard_price  # default to 'False'
    xml_accessor :cancel_line
  end
  
  class CustomItemAttribute < Node
    xml_name "Attribute"
    xml_reader :attribute_id, :from => '@attributeID'
    xml_reader :name, :from => '@name'
    xml_reader :value, :from => :content
  end

  class StandardResponse < Response
    xml_reader :success
	  xml_reader :errors, :as=>[Error], :in=>'ErrorData'

    def to_s
      error_string = self.errors.collect{ |e| e.message.to_s }.join(',')
      return "success: #{success}, errors: #{error_string}"
    end
  end
  
end
