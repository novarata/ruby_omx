module RubyOmx
  module Orders
    
    # Universal Direct Order Appending (UDOA)
    
    def build_udoa_request(params={})
		  UDOARequest.new(params.merge({:http_biz_id=>@http_biz_id, :udi_auth_token=>@udi_auth_token}))
		end
		
		def send_udoa_request(params={})
		  request = build_udoa_request(params)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      UDOAResponse.format(response)		  
		end
		alias_method :append_order, :send_udoa_request
		

		# Order Information
		
		def build_info_request(params={})
		  OrderInformationRequest.new(params.merge({:http_biz_id=>@http_biz_id, :udi_auth_token=>@udi_auth_token}))
		end

    def send_info_request(params={})
		  request = build_info_request(params)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      OrderInformationResponse.format(response)
    end


    # Smart Report Information

    def send_smart_report_request(params={})
      schedule_id = params[:schedule_id] ||= 1
      response = get("https://omx.ordermotion.com/en/net/SmartReports.aspx?HTTPBizID=#{@http_biz_id}&ScheduleID=#{schedule_id}")
      SmartReportResponse.format(response)
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
    
    #OrderDetailUpdateRequest (ODUR100)	This request type enables you to update certain data for orders.
		#CancellationHistoryRequest (CHR100)	This request type lists all the cancellations that have occurred between two dates.
		#InvoiceProcessRequest (IPR100)	This command takes an order number, and runs the invoicing and credit memo processes against the order if there are any order lines that can be subject to an invoice or credit memo, or if there are returns on the order.
		#OrderCancellationRequest (OCR100)	This request type enables you to cancel some or all the line items in an order.		
		#OrderSecondaryStatusUpdateRequest (OSSUR100)	This request type enables you to set the secondary status of the OrderLines.
		#OrderUpdateRequest (OUR200)	This request type enables you to change the Payment Plan of an order, as well as the basis date for payment plan calculation, and also update the "Alt ID 2" (a.k.a "Reference") field of the order.
		#OrderWaitDateUpdateRequest (OWDUR100)	This request type enables you to change the Wait Date of an existing order.  
=end