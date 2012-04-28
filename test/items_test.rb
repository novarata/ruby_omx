require 'test_helper'

class ItemsTest < MiniTest::Unit::TestCase
  def setup
		@config = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )['test']
		@connection = RubyOmx::Base.new(@config)
  end

  def test_get_item_information
    @connection.stubs(:post).returns(xml_for('ItemInformationResponse(1.00)',200))
    begin
      response = @connection.get_item_info()
    rescue MissingItemOptions
    end
    
    response = @connection.get_item_info(:item_code=>'01-114')
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
    @connection.stubs(:post).returns(xml_for('CustomItemAttributeInformationResponse(1.00)',200))
    begin
      response = @connection.get_custom_item_attribute_info()
    rescue MissingItemOptions
    end
    
    response = @connection.get_custom_item_attribute_info(:item_code=>'00001')
    assert_kind_of Hash, response.as_hash
    assert_equal '1', response.success
    i = response.items.first
    assert_equal '10100', i.item_code
    assert_equal 'True', i.active
    i_attrs = i.attributes
    assert_equal 20, i_attrs.length
    assert_equal '1', i_attrs.first.attribute_id
    assert_equal 'Keycode', i_attrs.first.name
    
    assert_kind_of Hash, response.as_hash
  end
  
end