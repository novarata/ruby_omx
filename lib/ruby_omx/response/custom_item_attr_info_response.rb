module RubyOmx
    
  class CustomItemAttribute < Response
    xml_name "Attribute"
    xml_reader :attribute_id, :from => '@attributeID'
    xml_reader :name, :from => '@name'
    xml_reader :value, :from => :content
  end
  
  class CIAIResponseItem < Response
    xml_name "Item"
    xml_reader :item_code, :from => '@itemCode'
    xml_reader :active, :from => '@active'
    xml_reader :attributes, :as => [CustomItemAttribute]
  end
    
  class CustomItemAttributeInformationResponse < Response
    xml_name "CustomItemAttributeInformationResponse"
         
    xml_reader :items, :as => [CIAIResponseItem], :in => "Items"
		xml_reader :success
		 	
		 	#xml_reader :item_code, :from => '@itemCode', :in => "Item"
		 	#xml_reader :active, :from => '@active', :in => "Item"
		 	#xml_reader :incomplete, :from => '@incomplete', :in => "Item"
		 	#xml_reader :parent_item_code, :from => '@parentItemCode', :in => "Item"
		 	
		 	
		 	#xml_reader :product_name, :in => "Item"
		 	#xml_reader :available_inventory, :as => Integer, :in => "Item"
		 	#xml_reader :sub_item_count, :as => Integer, :in => "Item"
		 	#xml_reader :last_updated_date, :as => DateTime, :in => "Item"
		 	#xml_reader :weight, :as => Float, :in => "Item"
		 	
		 	#xml_reader :price_type, :from => '@priceType', :in => 'Item/PriceData'
		 	#xml_reader :price_quantity, :from => '@quantity', :in => 'Item/PriceData/Price', :as => Integer
		 	#xml_reader :price_amount, :from => 'Amount', :in => 'Item/PriceData/Price', :as => Float
		 	#xml_reader :price_addl_sh, :from => 'AdditionalSH', :in => 'Item/PriceData/Price', :as => Float
		 	#xml_reader :bonus, :in => 'Item/PriceData/Price', :as => Float
		 	
  end
    
end
