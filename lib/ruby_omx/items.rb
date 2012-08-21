module RubyOmx
  module Items

		# ItemInformationRequest (ITIR100)	This request type lists the name, default prices, inventory availability, sub-items, cross-sell items, substitution items, and bundle items for a given item code.			

		def build_item_info_request(attrs={})
		  ItemInfoRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
		end

		def send_item_info_request(attrs={})
		  request = build_item_info_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      ItemInfoResponse.format(response)		  
		end
		alias_method :get_item_info, :send_item_info_request
		
	  # Customer Item Information Request
		
		def build_custom_item_info_request(attrs={})
		  CustomItemInfoRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))		  
		end
		
		def send_custom_item_info_request(attrs={})
		  request = build_custom_item_info_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      CustomItemInfoResponse.format(response)
		end
		alias_method :get_custom_item_info, :send_custom_item_info_request
  
  
    # Item Update Request
    
    def build_item_update_request(attrs={})
      ItemUpdateRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
    end

    def send_item_update_request(attrs={})
		  request = build_item_update_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      ItemUpdateResponse.format(response)		  
		end
		alias_method :append_item, :send_item_update_request


    # Item Price Update Request
    
    def build_item_price_update_request(attrs={})
      ItemPriceUpdateRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
    end

    def send_item_price_update_request(attrs={})
		  request = build_item_price_update_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      ItemPriceUpdateResponse.format(response)		  
		end
		alias_method :append_item_price, :send_item_price_update_request


    # Supplier Item Update Request
    
    def build_supplier_item_update_request(attrs={})
      SupplierItemUpdateRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
    end

    def send_supplier_item_update_request(attrs={})
		  request = build_supplier_item_update_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      SupplierItemUpdateResponse.format(response)		  
		end
		alias_method :append_supplier_item, :send_supplier_item_update_request

    # Inventory Availability
    
    def build_inventory_info_request(attrs={})
      InventoryInfoRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
    end

    def send_inventory_info_request(attrs={})
		  request = build_inventory_info_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      InventoryInfoResponse.format(response)
		end
		alias_method :fetch_inventory, :send_inventory_info_request

  end
end
