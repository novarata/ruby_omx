require 'test_helper'

class PurchaseOrdersTest < MiniTest::Unit::TestCase
  def setup
		@config = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )['test']
		@connection = RubyOmx::Base.new(@config)
		
		@line1 = { :item_code=>'WATCH-1', :quantity => 1, :price => 122.50 }
		@line2 = { :item_code=>'APPLE-12', :quantity => 31, :price => 1.50 }
  end
  
  def test_request_from_xml
    request = RubyOmx::PurchaseOrderUpdateRequest.format(xml_for('PurchaseOrderUpdateRequest(1.00)',200))
    assert_equal '1.00', request.version
    assert_equal '16651', request.po_number
    assert_equal '76', request.supplier_id
    assert_equal 2, request.line_items.length
    assert_equal @line1[:item_code], request.line_items[0].item_code
    assert_equal @line2[:item_code], request.line_items[1].item_code
    assert_equal 'True', request.line_items[0].cancel_line
    assert_equal 'True', request.line_items[1].cancel_line
  
    assert_equal 'UDIAuthToken', request.udi_parameters[0].key
    assert_equal @config['udi_auth_token'], request.udi_parameters[0].value
  end
  
  def test_send_purchase_order_update_request
  	@connection.stubs(:post).returns(xml_for('PurchaseOrderUpdateResponse(1.00)',200))
  	request = PurchaseOrderUpdateRequest.new
  	
  	# TODO why is this necessary
  	l1 = RubyOmx::LineItem.new(:item_code=>'WATCH-1', :quantity=>1, :price=>122.50)
  	l2 = RubyOmx::LineItem.new(:item_code=>'APPLE-12', :quantity=>31, :price=>1.50)
  	
  	po_data = { :po_number => '16651',
                :line_items => [l1, l2],
                :supplier_id => '76'
              }
	  r = @connection.build_purchase_order_update_request(po_data)
    assert_instance_of String, r.to_xml.to_s
		
  	# Missing Order Options
  	begin
  	  response = @connection.send_purchase_order_update_request({})
  	rescue MissingPurchaseOrderOptions
  	end
  
  	response = @connection.send_purchase_order_update_request(po_data)
  	assert_kind_of PurchaseOrderUpdateResponse, response
  	assert_equal '1', response.success
  	assert_equal DateTime.parse('2008-09-21 12:32:27'), response.po_date
  	assert_equal '16651', response.po_number
  	assert_equal '76', response.supplier_id
  	assert_kind_of Hash, response.as_hash

  	response = @connection.send_purchase_order_update_request(po_data.merge({:raw_xml => true}))
  	assert_kind_of Net::HTTPOK, response
	
  	# old alias should still work
  	response = @connection.append_po(po_data)		
  	assert_kind_of PurchaseOrderUpdateResponse, response
  	assert_equal '16651', response.po_number
  end
end