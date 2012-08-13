module RubyOmx

  class PurchaseOrderUpdateRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
      raise MissingRequestOptions if (attrs[:po_number].nil? && attrs[:supplier_id].nil?)
      super
      self.version = attrs[:version] ||= '1.00'

      # Instantiate LineItem variables for each
      self.line_items = attrs[:line_items].collect { |h| LineItem.new(h) }
    end
    
    xml_name "PurchaseOrderUpdateRequest"
    xml_accessor :po_number, :from=>'@PONumber', :in=>'PurchaseOrder' #<PurchaseOrder PONumber="16651" supplierID="76">
    xml_accessor :supplier_id, :from=>'@supplierID', :in=>'PurchaseOrder'
    xml_accessor :cross_reference #<CrossReference>PO 12345</CrossReference>
    xml_accessor :line_items, :as => [RubyOmx::LineItem], :in => 'PurchaseOrder/LineDetail'
  end
end
