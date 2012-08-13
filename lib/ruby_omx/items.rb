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

  end
end
