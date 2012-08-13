module RubyOmx
  
  class AttributeGroup < Node
    xml_name "AttributeGroup"
    xml_reader :name, :from=>'@name'
    xml_reader :group_id, :from=>'@groupID'
    xml_reader :attributes, :as => [CustomItemAttribute]
  end
  
  class CIAIResponseItem < Node
    xml_name "Item"
    xml_reader :item_code, :from => '@itemCode'
    xml_reader :active, :from => '@active'
    xml_reader :attribute_groups, :as=>[AttributeGroup]
  end
    
  class CustomItemInfoResponse < Response
    xml_name "CustomItemAttributeInformationResponse"         
    xml_reader :items, :as => [CIAIResponseItem], :in => "Items"
		xml_reader :success
		xml_reader :errors, :as=>[Error], :in=>'ErrorData'
  end
    
end
