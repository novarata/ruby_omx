module RubyOmx

  class Item < Node
    xml_name "Item"
    xml_accessor :item_code, :from=>'@itemCode'
    xml_accessor :supplier_id, :from=>'@supplierID'
    xml_accessor :supplier_item_code
    xml_accessor :description
    xml_accessor :standard_price, :as=>Float
    xml_accessor :delivery_lead_time_days, :as=>Integer
    xml_accessor :minimum_quantity, :as=>Integer
    xml_accessor :units_per_package, :as=>Integer
    xml_accessor :package_description
  end

  class SupplierItemUpdateRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
  		raise MissingRequestOptions if attrs[:items].nil?
      super
      self.version = attrs[:version] ||= '1.00'
      self.items = attrs[:items].collect { |h| Item.new(h) }
    end
        
    xml_name "SupplierItemUpdateRequest"
    xml_accessor :items, :as=>[Item], :in=>'Items'
  end

end