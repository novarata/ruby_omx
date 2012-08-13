module RubyOmx
  module PurchaseOrders
    
    def build_purchase_order_update_request(attrs={})
		  PurchaseOrderUpdateRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
		end
		
		def send_purchase_order_update_request(attrs={})
		  @connection = RubyOmx::Connection.connect({ "http_biz_id" => @http_biz_id, "udi_auth_token" => @udi_auth_token, "server"=>ALT_HOST })
		  request = build_purchase_order_update_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      PurchaseOrderUpdateResponse.format(response)		  
		end
		alias_method :append_po, :send_purchase_order_update_request
		
  end
end
