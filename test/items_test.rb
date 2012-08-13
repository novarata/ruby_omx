require 'test_helper'

class ItemsTest < MiniTest::Unit::TestCase
  def setup
		@config = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )['test']
		@connection = RubyOmx::Base.new(@config)
  end

  def test_item_info_request_from_xml
    request = RubyOmx::ItemInfoRequest.format(xml_for('ItemInformationRequest(1.00)',200))
    assert_equal '1.00', request.version
    assert_equal 'ItemCode', request.udi_parameters.last.key
    assert_equal '01-114', request.udi_parameters.last.value

    request = RubyOmx::CustomItemInfoRequest.format(xml_for('CustomItemAttributeInformationRequest(2.00)',200))
    assert_equal '2.00', request.version
    
    assert_equal 'AttributeGroupID', request.udi_parameters[3].key
    assert_equal '5', request.udi_parameters[3].value
    
    assert_equal 'ItemCode', request.udi_parameters[2].key
    assert_equal 'DANKITEM4-1', request.udi_parameters[2].value
  end

  def test_item_info_request_to_xml
    request_attrs = { :item_code => '01-114' }
    request = @connection.build_item_info_request(request_attrs)
    request2 = RubyOmx::ItemInfoRequest.format(xml_for('ItemInformationRequest(1.00)',200))
    assert_equal request.to_xml.to_s, request2.to_xml.to_s

    request_attrs = { :item_code => 'DANKITEM4-1', :attribute_group_id=>'5' }
    request = @connection.build_custom_item_info_request(request_attrs)
    request2 = RubyOmx::CustomItemInfoRequest.format(xml_for('CustomItemAttributeInformationRequest(2.00)',200))
    assert_equal request.to_xml.to_s, request2.to_xml.to_s
  end
    
  def test_get_item_information
    @connection.stubs(:post).returns(xml_for('ItemInformationResponse(1.00)',200))
    response = @connection.get_item_info() rescue MissingRequestOptions

    response = @connection.get_item_info({:item_code=>'01-114'})
    assert_equal '01-114', response.item_code
    assert_equal 'True', response.active
    assert_equal 'Driver', response.product_name
    assert_equal 1130, response.available_inventory
    assert_equal "Unit", response.price_type
    assert_equal "Restricted", response.quantity_type
    assert_equal 1, response.price_quantity
    assert_equal "True", response.price_multiplier
    assert_equal 2.02, response.price_amount
    assert_equal 1.20, response.price_addl_sh
    assert_equal 0.00, response.price_bonus
    assert_equal 6, response.custom_attributes.length
    assert_equal "1", response.custom_attributes.first.attribute_id
    assert_equal "MYAttribute1", response.custom_attributes.first.value
    assert_kind_of Hash, response.as_hash
  end
  
  def test_get_custom_item_attribute_information
    @connection.stubs(:post).returns(xml_for('CustomItemAttributeInformationResponse(2.00)',200))
    response = @connection.get_custom_item_info() rescue MissingRequestOptions
    
    response = @connection.get_custom_item_info(:item_code=>'00001')
    assert_kind_of Hash, response.as_hash
    assert_equal '1', response.success
    i = response.items.first
    assert_equal '00001', i.item_code
    assert_equal 'True', i.active
    i_attrs = i.attribute_groups.first.attributes
    assert_equal 1, i_attrs.length
    assert_equal '3', i_attrs.first.attribute_id
    assert_equal 'otrofield', i_attrs.first.name
    assert_kind_of Hash, response.as_hash
  end
  

  def test_item_update_request_from_xml
    request = RubyOmx::ItemUpdateRequest.format(xml_for('ItemUpdateRequest(2.00)',200))
    assert_equal '2.00', request.version
    assert_equal 1, request.items.length
    item = request.items.first
    assert_equal 'APPLE', item.item_code
  end

  def test_item_update_request_to_xml    

    request_attrs = {:items=> [{
      :item_code => 'APPLE',
      :product_status=>'True', 
      :incomplete_flag=>'False',
  		:product_name=>'Apple Product', 
  		:product_group=>45, 
  		:cost_of_goods=>10, 
  		:upc_code=>'234234234',	
  		:allow_order_line_info=>'True', 
  		:launch_date=>'2/23/2006', 
  		:file_sub_code=>20,
  		:inventory_product_flag=>'True', 
  		:tax_code=>'TC4', 
  		:inventory_type=>3,
  		:order_split_flag=>'True',
  		:drop_ship_file_sub_code=>31,
  		:inventory_manager=>'blah'
  		 }]}

    
    request = @connection.build_item_update_request(request_attrs)
    assert_instance_of String, request.to_xml.to_s
    
    @connection.stubs(:post).returns(xml_for('ItemUpdateResponse(2.00)',200))
    response = @connection.append_item rescue MissingRequestOptions

    response = @connection.append_item(request_attrs)
    assert_equal '1', response.success
  end
  
  
  def test_item_price_update_request_from_xml
    request = RubyOmx::ItemPriceUpdateRequest.format(xml_for('ItemPriceUpdateRequest(1.00)',200))
    assert_equal '1.00', request.version
    assert_equal 'unit', request.price_type
    assert_equal 'restricted', request.quantity_type
    assert_equal 1, request.price_points.length
    price_point = request.price_points.first
    assert_equal 10, price_point.quantity
    assert_equal 3.1415926535897932384626433832795, price_point.price
  end
  
  def test_item_price_update_request_to_xml    

    request_attrs = {
      :item_code=>'03-0303',
      :keycode=>'EVDE',
      :type=>'Keycode',
      :price_type=>'unit',
      :quantity_type=>'restricted',
      :price_points=>[{
        :quantity => 1,
        :price=>10.0,
        :shipping_handling=>1.0
  		 }]}
    
    request = @connection.build_item_price_update_request(request_attrs)
    assert_instance_of String, request.to_xml.to_s
    
    @connection.stubs(:post).returns(xml_for('ItemPriceUpdateResponse(1.00)',200))
    response = @connection.append_item_price rescue MissingRequestOptions

    response = @connection.append_item_price(request_attrs)
    assert_equal '1', response.success
    assert_equal 'success: 1, errors: ', response.to_s
  end  


  def test_supplier_item_update_request_from_xml
    request = RubyOmx::SupplierItemUpdateRequest.format(xml_for('SupplierItemUpdateRequest(1.00)',200))
    assert_equal '1.00', request.version
    assert_equal 1, request.items.length
    item = request.items.first
    assert_equal 11.22, item.standard_price
    assert_equal 50, item.minimum_quantity
    assert_equal "WID500a", item.item_code
    assert_equal '1', item.supplier_id
    assert_equal 2, item.units_per_package
    assert_equal 'large box', item.package_description
  end
  
  def test_supplier_item_update_request_to_xml    

    request_attrs = {:items=>[{
      :item_code=>'03-0303',
      :supplier_id=>'76',
      :supplier_item_code=>'03-0303',
      :description=>'Description',
      :standard_price=>10.5,
      :delivery_lead_time_days=>5,
      :minimum_quantity=>1,
      :units_per_package=>1,
      :package_description=>'Standard' }]
    }
    
    request = @connection.build_supplier_item_update_request(request_attrs)
    assert_instance_of String, request.to_xml.to_s
    
    @connection.stubs(:post).returns(xml_for('SupplierItemUpdateResponse(1.00)',200))
    response = @connection.append_supplier_item rescue MissingRequestOptions

    response = @connection.append_supplier_item(request_attrs)
    assert_equal '1', response.success
  end
  
end