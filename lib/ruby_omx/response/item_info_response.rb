module RubyOmx

  class ItemInfoResponse < Response
    xml_name "ItemInformationResponse"

	 	xml_reader :item_code, :from => '@itemCode', :in => "Item"
	 	xml_reader :active, :from => '@active', :in => "Item"
	 	xml_reader :incomplete, :from => '@incomplete', :in => "Item"
	 	xml_reader :parent_item_code, :from => '@parentItemCode', :in => "Item"
	 	xml_reader :product_name, :in => "Item"
	 	xml_reader :available_inventory, :as => Integer, :in => "Item"		 	
	 	xml_reader :price_type, :from => '@priceType', :in => 'Item/PriceData'
    xml_reader :quantity_type, :from => '@quantityType', :in => 'Item/PriceData'
	 	xml_reader :price_quantity, :from => '@quantity', :in => 'Item/PriceData/Price', :as => Integer
    xml_reader :price_multiplier, :from => '@multiplier', :in => 'Item/PriceData/Price'
	 	xml_reader :price_amount, :from => 'Amount', :in => 'Item/PriceData/Price', :as => Float
	 	xml_reader :price_addl_sh, :from => 'AdditionalSH', :in => 'Item/PriceData/Price', :as => Float
	 	xml_reader :price_bonus, :from => 'Bonus', :in => 'Item/PriceData/Price', :as => Float
	 	xml_reader :custom_attributes, :as => [CustomItemAttribute], :in => 'Item/CustomItemAttribute'
		xml_reader :errors, :as=>[Error], :in=>'ErrorData'
  end
    
end
