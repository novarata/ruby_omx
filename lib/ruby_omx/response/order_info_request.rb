#$wtf = "https://api.omx.ordermotion.com/hdde/xml/udi.asp?Wrapper=1&RequestType=OrderInformationRequest&RequestVersion=1.00&HTTPBizID=".BIZ_ID."&OrderNumber=".$OMorderid."&level=$level";
module RubyOmx

  class OrderInformationRequest < Response
    def initialize(a=nil)
      return super unless a.present? # bail if no array of options has been given
      http_biz_id = a.delete(:http_biz_id)
      udi_auth_token = a.delete(:udi_auth_token)
      #udi_auth_token = a.delete(:udi_auth_token)
      
		  required_fields = [:order_number]
		  raise MissingOrderOptions if required_fields.any? { |option| a[option].nil? }
      super
      self.version = a[:version] ||= '1.00'
      
      self.udi_parameters = [ RubyOmx::UDIParameter.new({:key=>'UDIAuthToken', :value=>udi_auth_token}),
                              RubyOmx::UDIParameter.new({:key=>'HTTPBizID', :value=>http_biz_id}),
                              RubyOmx::UDIParameter.new({:key=>'OrderNumber', :value=>a[:order_number]}),
                              RubyOmx::UDIParameter.new({:key=>'level', :value=>a[:level] ||=0 })]
    end
    
    attr_accessor :order_number, :raw_xml
    
    xml_name "OrderInformationRequest"
    xml_accessor :version, :from => '@version'
    xml_accessor :udi_parameters, :as => [RubyOmx::UDIParameter], :in => 'UDIParameter'
  end
end
