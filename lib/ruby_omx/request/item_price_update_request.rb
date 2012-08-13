module RubyOmx

  class PricePoint < Node
    xml_name "PricePoint"
    xml_accessor :quantity, :as=>Integer
    xml_accessor :price, :as=>Float
    xml_accessor :shipping_handling, :as=>Float
    xml_accessor :multiplier, :from => '@multiplier'
  end

  class ItemPriceUpdateRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
      required_fields = [:item_code, :keycode, :type] #:item_code, :product_status, :product_name, :product_group, :tax_code, :file_sub_code, :inventory_product_flag, :launch_date
  		raise MissingRequestOptions if required_fields.any? { |option| attrs[option].nil? }  		
      super
      self.version = attrs[:version] ||= '2.00'
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'ItemCode', :value=>attrs[:item_code]})
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'Keycode', :value=>attrs[:keycode]})
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'Type', :value=>attrs[:type]})
      self.price_points = attrs[:price_points].collect { |h| PricePoint.new(h) }
    end
    
    attr_accessor :item_code, :keycode, :type
    
    xml_name "ItemPriceUpdateRequest"
    xml_accessor :price_type, :from=>'@priceType', :in=>'PricePoints'
    xml_accessor :quantity_type, :from=>'@quantityType', :in=>'PricePoints'
    xml_accessor :price_points, :as=>[PricePoint], :in=>'PricePoints'
  end

end