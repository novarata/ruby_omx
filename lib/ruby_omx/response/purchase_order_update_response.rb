#<PurchaseOrderUpdateResponse>
# <Success>1</Success>
# <PurchaseOrder PONumber="16651" SupplierID="76"/>
# <PODate>2008-09-21 12:32:27</PODate>
# <TotalAmount>26.50</TotalAmount>
# <Action>New</Action> <!-- "New" if a new PO number was just assigned, "Update" if a PO number was supplied and the PO's header properties were changed, and/or a PO line was added or updated. -->
#</PurchaseOrderUpdateResponse>

#OrderInformationRequest (OIR200)	This request type provides the ShippingInformationRequest (SIR) result for the order as a whole.

module RubyOmx

  class PurchaseOrderResponse < Response
    xml_name 'PurchaseOrder'
    xml_accessor :po_number, :from=>'@PONumber' #<PurchaseOrder PONumber="16651" SupplierID="76">
    xml_accessor :supplier_id, :from=>'@SupplierID'
  end

  class PurchaseOrderUpdateResponse < Response
    xml_name "PurchaseOrderUpdateResponse"
    xml_reader :success
    xml_accessor :purchase_order, :as => RubyOmx::PurchaseOrderResponse
    xml_accessor :po_date, :from=>'PODate', :as=>DateTime
    xml_accessor :total_amount, :as=>Float
    xml_accessor :action    
  end
    
end
