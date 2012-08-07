#$wtf = "https://api.omx.ordermotion.com/hdde/xml/udi.asp?Wrapper=1&RequestType=OrderInformationRequest&RequestVersion=1.00&HTTPBizID=".BIZ_ID."&OrderNumber=".$OMorderid."&level=$level";
module RubyOmx

  class OrderInformationRequest < Response
    def initialize(a=nil)
      return super unless a.present? # bail if no array of options has been given
      http_biz_id = a.delete(:http_biz_id)
      udi_auth_token = a.delete(:udi_auth_token)
            
      raise MissingOrderOptions if a[:order_number].nil? && (a[:store_code].nil? || a[:order_id].nil?)
      super
      self.version = a[:version] ||= '2.00'
      
      self.udi_parameters = []
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'UDIAuthToken', :value=>udi_auth_token})
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'HTTPBizID', :value=>http_biz_id})
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'OrderNumber', :value=>a[:order_number]}) if a[:order_number]
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'OrderId', :value=>a[:order_id]}) if a[:order_id]
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'StoreCode', :value=>a[:store_code]}) if a[:store_code]
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'level', :value=>a[:level] ||=2 })
    end
    
    attr_accessor :order_number, :order_id, :store_code, :raw_xml
    
    xml_name "OrderInformationRequest"
    xml_accessor :version, :from => '@version'
    xml_accessor :udi_parameters, :as => [RubyOmx::UDIParameter], :in => 'UDIParameter'
  end
end
