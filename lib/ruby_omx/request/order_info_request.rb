module RubyOmx

  class OrderInfoRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
      
      # Require either an order number or a store code and an order id to locate the order
      raise MissingRequestOptions if attrs[:order_number].nil? && (attrs[:store_code].nil? || attrs[:order_id].nil?)
      super
      self.version = attrs[:version] ||= '1.00'
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'OrderNumber', :value=>attrs[:order_number]}) if attrs[:order_number]
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'OrderID', :value=>attrs[:order_id]}) if attrs[:order_id]
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'StoreCode', :value=>attrs[:store_code]}) if attrs[:store_code]
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'level', :value=>attrs[:level] ||=2 })
    end
    
    attr_accessor :order_number, :order_id, :store_code
    
    xml_name "OrderInformationRequest"
  end
end
