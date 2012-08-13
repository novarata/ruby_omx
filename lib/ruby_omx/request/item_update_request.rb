module RubyOmx

  class ItemUpdateItem < Node
    xml_accessor :item_code #<ItemCode>APPLE</ItemCode>
    xml_accessor :product_status #<ProductStatus>True</ProductStatus>
    xml_accessor :incomplete_flag #<IncompleteFlag>True</IncompleteFlag>
		xml_accessor :product_name #<ProductName>Deluxe Princess Fiona™ Child</ProductName>
		xml_accessor :product_group, :as=>Integer #<ProductGroup>45</ProductGroup>
		xml_accessor :cost_of_goods, :as=>Float #<CostOfGoods>10</CostOfGoods>
		xml_accessor :upc_code, :from=>'UPCCode'	#<UPCCode></UPCCode>
		xml_accessor :accounting_reference #<AccountingReference></AccountingReference>
		xml_accessor :allow_order_line_info #<AllowOrderLineInfo>True</AllowOrderLineInfo>
		xml_accessor :launch_date #<LaunchDate>2/23/2006</LaunchDate>
		xml_accessor :file_sub_code, :as=>Integer #<FileSubCode>20</FileSubCode>
		xml_accessor :inventory_product_flag #<InventoryProductFlag>True</InventoryProductFlag>
		xml_accessor :tax_code #<TaxCode>TC4</TaxCode>
		xml_accessor :inventory_type, :as=>Integer # <InventoryType>3</InventoryType>    
    xml_accessor :drop_ship_file_sub_code, :as=>Integer #<DropShipFileSubCode>31</DropShipFileSubCode>
    xml_accessor :order_split_flag #<OrderSplitFlag>False</OrderSplitFlag>		
    xml_accessor :inventory_manager
    xml_accessor :inventory_warning_ooi, :from=>'InventoryWarningOOI' #<InventoryWarningOOI>False</InventoryWarningOOI>
		xml_accessor :inventory_warning_loi, :from=>'InventoryWarningLOI' #<InventoryWarningLOI>False</InventoryWarningLOI>		
  end

  class ItemUpdateRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
      required_fields = [:items] #:item_code, :product_status, :product_name, :product_group, :tax_code, :file_sub_code, :inventory_product_flag, :launch_date
  		raise MissingRequestOptions if required_fields.any? { |option| attrs[option].nil? }  		
      super
      self.version = attrs[:version] ||= '2.00'
      self.items = attrs[:items].collect { |h| ItemUpdateItem.new(h) }
    end
    
    xml_name "ItemUpdateRequest"
    xml_accessor :items, :as=>[ItemUpdateItem], :in=>'Items'
  end

end
