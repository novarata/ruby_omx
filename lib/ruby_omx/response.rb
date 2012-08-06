module RubyOmx
   
  class Response
    include ROXML
    xml_convention :camelcase
    
    def initialize(object_attribute_hash=nil)
      object_attribute_hash.map { |(k, v)| send("#{k}=", v) } if object_attribute_hash.present?
   end

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
      
    def accessors
      roxml_references.map {|r| r.accessor}
    end

    # render a ROXML object as a normal hash, eliminating the @ and some unneeded admin fields
  	def as_hash
  		obj_hash = {}
  		self.instance_variables.each do |v|
  			m = v.to_s.sub('@','')
  			if m != 'roxml_references' && m!= 'promotion_ids'
  				obj_hash[m.to_sym] = self.instance_variable_get(v)
  			end
  		end
  		obj_hash
  	end

  end
end
