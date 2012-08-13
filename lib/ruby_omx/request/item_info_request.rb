module RubyOmx

  class ItemInfoRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
  	  raise MissingRequestOptions if attrs[:item_code].nil?
      super
      self.version = attrs[:version] ||= '1.00'
      self.udi_parameters << UDIParameter.new({:key=>'ItemCode', :value=>attrs[:item_code]})      
    end
    
    attr_accessor :item_code
    xml_name "ItemInformationRequest"
  end
end