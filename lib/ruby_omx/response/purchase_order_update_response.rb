#OrderInformationRequest (OIR200)	This request type provides the ShippingInformationRequest (SIR) result for the order as a whole.
module RubyOmx

  class PurchaseOrderUpdateResponse < Response
    xml_name "PurchaseOrderUpdateResponse"
    xml_reader :success
    #xml_accessor :purchase_order, :as => RubyOmx::PurchaseOrderResponse
    xml_accessor :po_number, :from=>'@PONumber', :in=>'PurchaseOrder' #<PurchaseOrder PONumber="16651" SupplierID="76">
    xml_accessor :supplier_id, :from=>'@SupplierID', :in=>'PurchaseOrder'

    xml_accessor :po_date, :from=>'PODate', :as=>DateTime
    xml_accessor :total_amount, :as=>Float
    xml_accessor :action
    xml_accessor :errors, :as=>[RubyOmx::ErrorData], :in=>'ErrorData'
  end
    
end
