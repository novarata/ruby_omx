require 'test_helper'

class OrdersTest < MiniTest::Unit::TestCase
  def setup
		@config = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )['test']
		@connection = RubyOmx::Base.new(@config)
		
		# Alternative connection needed for v2 of OMX API (but not for UDOA)
		@config_alt = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )['test_alt']
		@connection_alt = RubyOmx::Base.new(@config_alt)
  end

  def test_orders_request_from_xml
    request = RubyOmx::UDOARequest.format(xml_for('UDOARequest_(UDOA200)_request',200))
    assert_equal '2.00', request.version
    
    assert_equal 'UDIAuthToken', request.udi_parameters[0].key
    assert_equal @config['udi_auth_token'], request.udi_parameters[0].value

    assert_equal 'HTTPBizID', request.udi_parameters[1].key
    assert_equal @config['http_biz_id'], request.udi_parameters[1].value
    
    assert_equal 'Keycode', request.udi_parameters[2].key
    assert_equal 'JTESTKEY', request.udi_parameters[2].value

    assert_equal 'VerifyFlag', request.udi_parameters[3].key
    assert_equal 'False', request.udi_parameters[3].value

    assert_equal 'QueueFlag', request.udi_parameters[4].key
    assert_equal 'False', request.udi_parameters[4].value


    assert_equal DateTime.parse('2003-04-01 22:15:10'), request.order_date
    assert_equal '3', request.origin_type
    assert_equal 'XXX', request.store_code

    assert_equal 'BillTo', request.bill_to.address_type
    assert_equal '0', request.bill_to.title_code
    assert_equal '', request.bill_to.company
    assert_equal 'Bill', request.bill_to.firstname
    assert_equal 'Thomas', request.bill_to.lastname
    assert_equal '251 West 30th St', request.bill_to.address1
    assert_equal '', request.bill_to.email

    assert_equal 'ShipTo', request.ship_to.address_type
    assert_equal '0', request.ship_to.title_code
    assert_nil request.ship_to.company
    assert_equal 'Maurice', request.ship_to.firstname
    assert_equal 'Evans', request.ship_to.lastname
    assert_equal '65 West 83rd St, Apt 4A', request.ship_to.address1
    assert_nil request.ship_to.email

    assert_equal 0, request.method_code
    assert_equal 8.75, request.shipping_amount
    assert_equal 0, request.handling_amount
    assert_equal 'Please wrap this carefully', request.special_instructions
    assert_equal 'True', request.gift_wrapping
    assert_equal 'Happy Birthday Mauro!!', request.gift_message
    
    assert_equal '1', request.payment_type
    assert_equal '4111111111111111', request.card_number
    assert_equal '222', request.card_verification
    assert_equal '09', request.card_exp_date_month
    assert_equal '2009', request.card_exp_date_year
    assert_equal '11', request.card_status
    assert_equal '010101', request.card_auth_code
    assert_equal '123456789', request.card_transaction_id

    assert_equal '1', request.line_items[0].line_number
    assert_equal 'APPLE', request.line_items[0].item_code
    assert_equal 1, request.line_items[0].quantity
    assert_equal 'WATCH', request.line_items[1].item_code
    
    assert_equal '2', request.custom_fields[0].field_id
    assert_equal '1', request.custom_fields[0].line_number
    assert_equal 'a', request.custom_fields[0].value
    assert_equal 12, request.custom_fields.length
    
  end

  def test_orders_request_to_xml    
    request_attrs = {
      :raw_xml => 0,
      :keycode => 'JTESTKEY',
      :verify_flag => 'False',
      :queue_flag => 'False',
      :order_date => DateTime.parse('2003-04-01 22:15:10'),
      :order_id => '234-23423423',
      :origin_type => '3', 
      :store_code => 'XXX',
      :flags => [ { :name=>'DoNotMail', :value=>'True' },
                  { :name=>'DoNotCall', :value=>'True' },
                  { :name=>'DoNotEmail', :value=>'True' }],
      :bill_to => { :address_type=>'BillTo',
                    :title_code => '0',
                    :company => '',
                    :firstname => 'Bill',
                    :lastname => 'Thomas',
                    :address1 => '251 West 30th St',
                    :address2 => 'Apt 12E',
                    :city => 'New York', 
                    :state => 'NY',
                    :zip => '10001',
                    :tld => 'US',
                    :phone_number => '',
                    :email => ''},
      :ship_to => { :address_type=>'ShipTo',
                    :title_code=>'0',
                    :firstname=>'Maurice',
                    :lastname=>'Evans',
                    :address1=>'65 West 83rd St, Apt 4A',
                    :address2=>'',
                    :city=>'New York',
                    :state=>'NY',
                    :zip => '10024', 
                    :tld => 'US'},
      :method_code => 0,
      :shipping_amount => 8.75,
      :handling_amount => 0.0,
      :special_instructions => 'Please wrap this carefully',
      :gift_wrapping => 'True', 
      :gift_message => 'Happy Birthday Mauro!!',
      :payment_type => '1',
      :card_number => '4111111111111111',
      :card_verification => '222',
      :card_exp_date_month => '09',
      :card_exp_date_year => '2009',
      :card_status => '11',
      :card_auth_code => '010101',
      :card_transaction_id => '123456789',
      :line_items => [{ :item_code => 'APPLE', :quantity => 1 },
                      { :item_code => 'WATCH', :quantity => 1 }],
      :custom_fields => [ { :field_id => '2', :line_number => '1', :value => 'a' },
                          { :field_id => '3', :line_number => '1', :value => 'a' },
                          { :field_id => '4', :line_number => '1', :value => 'a' },
                          { :field_id => '5', :line_number => '1', :value => 'a' },
                          { :field_id => '6', :line_number => '1', :value => 'a' },
                          { :field_id => '7', :line_number => '1', :value => 'a' },
                          { :field_id => '2', :line_number => '2', :value => 'a' },
                          { :field_id => '3', :line_number => '2', :value => 'a' },
                          { :field_id => '4', :line_number => '2', :value => 'a' },
                          { :field_id => '5', :line_number => '2', :value => 'a' },
                          { :field_id => '6', :line_number => '2', :value => 'a' },                                                                                                                                                                                                                                          
                          { :field_id => '7', :line_number => '2', :value => 'a' }]
    }
    request = @connection.build_udoa_request(request_attrs)
    request2 = RubyOmx::UDOARequest.format(xml_for('UDOARequest_(UDOA200)_request',200))
    assert_equal request.to_xml.to_s, request2.to_xml.to_s
  end

  def test_send_udoa_request
  	@connection.stubs(:post).returns(xml_for('UDOARequest_(UDOA200)_response',200))
  	order_data = {
		  :keycode => 'TS01',
		  :vendor => '',
		  :queue_flag => 'False',
		  :verify_flag => 'True',
		  :order_date => Time.now.to_s(:db),
		  :order_id => '23423423423423',
		  :bill_to => { :lastname => 'Jim Smith'},
		  :line_items => [{ :quantity => 2, :unit_price => 5.00 }],
		  :method_code => '9' 
  	}
  	
  	# Missing Order Options
  	begin
  	  response = @connection.send_udoa_request(order_data)
  	rescue MissingOrderOptions
  	end
    
    order_data[:line_items][0].merge!({ :item_code => 'SKU' })
		response = @connection.send_udoa_request(order_data)

		assert_kind_of UDOAResponse, response
		assert !response.accessors.include?("code")
		assert_equal 'OMX-ofyccytnacrtnedlldmyed', response.OMX
		assert_equal '10512', response.order_number
		
		assert_kind_of Hash, response.as_hash

		response = @connection.send_udoa_request(order_data.merge({:raw_xml => true}))
		assert_kind_of Net::HTTPOK, response
		
		# old alias should still work
		response = @connection.append_order(order_data)		
		assert_kind_of UDOAResponse, response
		assert_equal 'OMX-ofyccytnacrtnedlldmyed', response.OMX
  end
  
  def test_send_info_request1
  	@connection.stubs(:post).returns(xml_for('OrderInformationResponse(1.00)',200))
		response = @connection.send_info_request({ :order_number => '16651' })
		assert_kind_of OrderInformationResponse, response
		assert !response.accessors.include?("code")

    assert_equal DateTime.parse('2006-02-09 14:47:00'), response.ship_date
    assert_equal '11229', response.customer_number
    assert_equal "", response.tracking_number
    assert_equal '16651', response.order_header.order_number
    assert_equal DateTime.parse('2005-06-20 14:25:00'), response.order_header.order_date
    assert_equal 1, response.line_items.length
    assert_equal '16651-1', response.line_items[0].shipment_number
    assert_equal 6.52, response.line_items[0].line_cogs
    assert_equal 6.52, response.line_items[0].unit_cogs
    assert_equal '01-113', response.line_items[0].supplier_item_code
    assert_equal '01-113', response.line_items[0].item_code
    assert_instance_of OrderInfoLineStatus, response.line_items[0].line_status
    assert_equal "OK", response.line_items[0].line_status.text
    assert_equal 40, response.line_items[0].line_status.value  
    assert_equal '2/9/2006 2:47:00 PM', response.line_items[0].line_status.date
		assert_kind_of Hash, response.as_hash
  end

  def test_send_info_request2
  	@connection_alt.stubs(:post).returns(xml_for('OrderInformationResponse(2.00)',200))
		response = @connection_alt.send_info_request({ :order_number => '24603', :version=>'2.00' })
		assert_kind_of OrderInformationResponse, response

    assert_nil response.ship_date
    assert_equal "", response.tracking_number

    assert_nil response.order_header.order_id    
    assert_equal '24603', response.order_header.order_number
    assert_equal DateTime.parse('2003-04-01 22:15:00'), response.order_header.order_date
    assert_equal DateTime.parse('2010-05-31 05:36:00'), response.order_header.order_status_date
    assert_equal '4', response.order_header.order_status_code

    assert_equal '11552', response.customer_number
    assert_equal 2, response.line_items.length
    assert_equal '24603-0', response.line_items[0].shipment_number
    assert_equal 10, response.line_items[0].line_cogs
    assert_equal 10, response.line_items[0].unit_cogs

    assert_equal 'APPLE', response.line_items[0].warehouse_reference
    assert_equal 'APPLE', response.line_items[0].item_code
    assert_equal 'APPLE', response.line_items[0].supplier_item_code
    
    assert_instance_of OrderInfoLineStatus, response.line_items[0].line_status
    assert_equal "OK", response.line_items[0].line_status.text
    assert_equal 40, response.line_items[0].line_status.value  
    assert_equal '5/31/2010 5:36:00 AM', response.line_items[0].line_status.date
		assert_kind_of Hash, response.as_hash
		
		response = @connection_alt.send_info_request({ :order_id=> 'AZ-43253-234', :store_code=>'XX01', :version=>'2.00' })
		assert_kind_of OrderInformationResponse, response
  end
  
  def test_send_smart_report_request
  	@connection.stubs(:get).returns(xml_for('SmartReports',200))
		response = @connection.send_smart_report_request
		assert_kind_of SmartReportResponse, response
		assert_equal 2, response.rows.length
		assert_equal 12, response.rows[0].fields.length
		assert_equal '1', response.rows[0].fields[0].id
		assert_equal '12432343', response.rows[0].fields[0].value
		assert_kind_of Hash, response.as_hash
  end
  
end