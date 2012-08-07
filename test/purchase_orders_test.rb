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
    assert_equal '16651', request.purchase_order.po_number
    assert_equal '76', request.purchase_order.supplier_id
    assert_equal 2, request.purchase_order.line_items.length
    assert_equal @line1[:item_code], request.purchase_order.line_items[0].item_code
    assert_equal @line2[:item_code], request.purchase_order.line_items[1].item_code
  
    assert_equal 'UDIAuthToken', request.udi_parameters[0].key
    assert_equal @config['udi_auth_token'], request.udi_parameters[0].value
  end
  
  def test_send_purchase_order_update_request
  	@connection.stubs(:post).returns(xml_for('PurchaseOrderUpdateResponse(1.00)',200))
  	request = PurchaseOrderUpdateRequest.new
  	po_data = { :purchase_order => {
  	              :po_number => '16651',
  	              :supplier_id => '76',
  	              :line_items => [@line1, @line2]
  	            }
  	          }
	
  	# Missing Order Options
  	begin
  	  response = @connection.send_purchase_order_update_request({})
  	rescue MissingPurchaseOrderOptions
  	end
  
  	response = @connection.send_purchase_order_update_request(po_data)
  	assert_kind_of PurchaseOrderUpdateResponse, response
  	assert_equal '1', response.success
  	assert_equal DateTime.parse('2008-09-21 12:32:27'), response.po_date
  	assert_equal '16651', response.purchase_order.po_number
  	assert_equal '76', response.purchase_order.supplier_id
  	assert_kind_of Hash, response.as_hash

  	response = @connection.send_purchase_order_update_request(po_data.merge({:raw_xml => true}))
  	assert_kind_of Net::HTTPOK, response
	
  	# old alias should still work
  	response = @connection.append_po(po_data)		
  	assert_kind_of PurchaseOrderUpdateResponse, response
  	assert_equal '16651', response.purchase_order.po_number
  end
end