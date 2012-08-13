module RubyOmx

  class CustomItemInfoRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
  	  raise MissingRequestOptions if attrs[:item_code].nil?
      super
      self.version = attrs[:version] ||= '2.00'
      self.udi_parameters << UDIParameter.new({:key=>'ItemCode', :value=>attrs[:item_code]})
      self.udi_parameters << UDIParameter.new({:key=>'AttributeGroupID', :value=>(attrs[:attribute_group_id]||='All')})
      
    end
    attr_accessor :item_code, :attribute_group_id
    xml_name "CustomItemAttributeInformationRequest"
  end
end