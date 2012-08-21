module RubyOmx

  class InventoryInfoRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
  	  raise MissingRequestOptions if attrs[:items].nil?
      super
      self.version = attrs[:version] ||= '1.00'
      self.udi_parameters << UDIParameter.new({:key=>'RealNonInventoryItemAvailability', :value=>attrs[:real_non_inventory_item_availability] || 'True' })      
      self.items = attrs[:items].collect { |h| Item.new(h) }
    end

    xml_name "InventoryInformationRequest"
    xml_accessor :items, :as=>[Item], :in=>'Items'

  end
end