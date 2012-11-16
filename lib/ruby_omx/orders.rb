module RubyOmx
  module Orders
    
    # Status mapping
    FULFILL_STATUS = {
      '0'=>'pending',
      '2'=>'clearing',
      '3'=>'backordered',
      '5'=>'on hold',
      '8'=>'held-to-complete',
      '20'=>'backordered',
      '28'=>'held-to-complete',
      '30'=>'warehouse',
      '40'=>'shipped',
      '50'=>'returned',
      '52'=>'pending returned',
      '90'=>'cancelled', 
      '95'=>'auto-cancelled',
      '96'=>'voided shipment' 
    }
    PENDING_STATUS = ['0','2','28','30','52']   # actual status is pending an OMX data delivery
    BACKORDER_STATUS = [ '3', '20','5','8']     # needs fulfillment attention
    SHIPPED_STATUS = ['40']                     # has or will soon ship (may come back)
    RETURN_STATUS = ['50']                      # has been returned
    CANCEL_STATUS = ['90','95','96']            # has been cancelled
    
    
    # Universal Direct Order Appending (UDOA)
    
    def build_udoa_request(attrs={})
		  UDOARequest.new(attrs.merge({:http_biz_id=>@http_biz_id, :udi_auth_token=>@udi_auth_token}))
		end
		
		def send_udoa_request(attrs={})
		  request = build_udoa_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      UDOAResponse.format(response)
		end
		alias_method :append_order, :send_udoa_request
		

		# Order Information
		
		def build_info_request(attrs={})
	    OrderInfoRequest.new(attrs.merge({:http_biz_id=>@http_biz_id, :udi_auth_token=>@udi_auth_token}))
		end

    def send_info_request(attrs={})
	    @connection = RubyOmx::Connection.connect({ "http_biz_id" => @http_biz_id, "udi_auth_token" => @udi_auth_token, "server"=>ALT_HOST }) if attrs[:version].present? && attrs[:version]=='2.00'
		  request = build_info_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      OrderInfoResponse.format(response)
    end


		#CancellationHistoryRequest (CHR100)	This request type lists all the cancellations that have occurred between two dates.
    def send_cancellation_history_request(attrs={})
      request = CancellationHistoryRequest.new(attrs.merge({:http_biz_id=>@http_biz_id, :udi_auth_token=>@udi_auth_token}))
      response = get(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      CancellationHistoryResponse.format(response)
    end
    
    # ReturnHistoryRequest (RHR100)  This request returns a list of all the product returns that have happened within a target date/time range, with basic information about these returns.
    def send_return_history_request(attrs={})
      request = ReturnHistoryRequest.new(attrs.merge({:http_biz_id=>@http_biz_id, :udi_auth_token=>@udi_auth_token}))
      response = get(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      ReturnHistoryResponse.format(response)
    end
  end

end


=begin
  		# Shipping Methods (numeric inputs to MethodCode)
  		# 0	UPS Ground (1-4 Days Transit Time)	 	0.00	
  		# 2	Drop-Ship Montague	1	40.00	
  		# 1	UPS Free UPS Ground Shipping (US ONLY)	0	0.00	
  		# 3	UPS Ground	003	0.00	
  		# 4	UPS 2nd Day Air	002	0.00	
  		# 5	UPS Next Day Air	001	0.00	
  		# 7	UPS 3 Day Select	004	0.00	
  		# 12	UPS Worldwide Expedited	008	0.00	
  		# 13	UPS Worldwide Express	009	0.00	
  		# 14	UPS Worldwide Express Plus	010	0.00	
  		# 6	International Flat Rate via USPS Express	2	35.00
  		# 8	USPS Express	 	29.99	
  		# 9	USPS Priority	 	6.99	
  		# 10	Int. Express USPS	 	0.00	
  		# 11	Int. Priority USPS	 	0.00	
  		# 15	USPS Domestic Priority Flat Rate	 	6.99	
  		# 16	USPS Domestic Express Flat Rate	 	34.99	
  		# 17	USPS International Global Priority	 	29.99	
  		# 18	USPS International Global Express	 	39.99	
  		# 19	Next Day Air (USA Only)	 	0.00	
  		# 20	2nd Day Air (USA Only)	 	0.00	
  		# 21	Priority Mail (Free $74.99 and above), 3-6 days 0.00    
=end