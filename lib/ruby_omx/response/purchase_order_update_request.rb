module RubyOmx

  class PurchaseOrderLineItem < Response
    xml_name 'LineItem'
    xml_accessor :line_number, :from=>'@lineNumber'
    xml_accessor :item_code # 
    xml_accessor :quantity # required for new line, optional for update (if omitted, existing value is not changed)
    xml_accessor :price # required for new line, optional for update (if omitted, existing value is not changed)
  end

  class PurchaseOrder < Response
    xml_name 'PurchaseOrder'
    xml_accessor :po_number, :from=>'@PONumber' #<PurchaseOrder PONumber="16651" supplierID="76">
    xml_accessor :supplier_id, :from=>'@supplierID'
    xml_accessor :line_items, :as=>[PurchaseOrderLineItem], :in => 'LineDetail'
  end

  class PurchaseOrderUpdateRequest < Response
    def initialize(a=nil)
      return super unless a.present? # bail if no array of options has been given
      http_biz_id = a.delete(:http_biz_id)
      udi_auth_token = a.delete(:udi_auth_token)
      #udi_auth_token = a.delete(:udi_auth_token)
      
		  required_fields = [:purchase_order]
		  raise MissingPurchaseOrderOptions if required_fields.any? { |option| a[option].nil? }
		  raise MissingPurchaseOrderOptions if a[:purchase_order][:po_number].nil? && a[:purchase_order][:supplier_id].nil?
		  raise MissingPurchaseOrderOptions if a[:purchase_order][:line_items].nil?
      super
      self.version = a[:version] ||= '1.00'
      self.udi_parameters = []
      self.udi_parameters << UDIParameter.new({:key=>'UDIAuthToken', :value=>udi_auth_token})
      self.udi_parameters << UDIParameter.new({:key=>'HTTPBizID', :value=>http_biz_id})      
    end
    
    attr_accessor :raw_xml
    
    xml_name "PurchaseOrderUpdateRequest"
    xml_accessor :version, :from => '@version'
    xml_accessor :udi_parameters, :as => [RubyOmx::UDIParameter], :in => 'UDIParameter'
    xml_accessor :purchase_order, :as => PurchaseOrder
  end
end
