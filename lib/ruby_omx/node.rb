module RubyOmx
   
  # Base class for request and response classes, which implement XML mapping via ROXML
  class Node
    include ROXML
    xml_convention :camelcase
    
    def initialize(attrs={})
      attrs.map { |(k, v)| send("#{k}=", v) } if attrs.present?
    end

    def accessors
      roxml_references.map {|r| r.accessor}
    end

    # render a ROXML node as a normal hash, eliminating the @ and some unneeded admin fields
  	def as_hash
  		obj_hash = {}
  		self.instance_variables.each do |v|
  			m = v.to_s.sub('@','')
  			if m != 'roxml_references' && m!= 'promotion_ids'
  				obj_hash[m.to_sym] = self.instance_variable_get(v)
  			end
  		end
  		return obj_hash
  	end

  end

end
