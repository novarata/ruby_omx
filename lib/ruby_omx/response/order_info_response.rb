#OrderInformationRequest (OIR200)	This request type provides the ShippingInformationRequest (SIR) result for the order as a whole.

module RubyOmx

  class OrderInfoLineStatus < Response
    xml_name "LineStatus"
    #<LineStatus date="2/9/2006 2:47:00 PM" text="OK">40</LineStatus>
    xml_reader :text, :from => '@text'  # C/L means cancelled, OK with a date means processing
    xml_reader :date, :from => '@date', :as=>DateTime # cancellation date if cancelled, processing date if processing
    xml_reader :value, :from => :content, :as=>Integer
  end
  
  class OrderInfoOrderHeader < Response
    xml_name "OrderHeader"
    xml_reader :order_id
    xml_reader :order_number
    xml_reader :order_date, :as=>DateTime
  end
      
  class OrderInfoLineItem < Response
    xml_name "LineItem"
    xml_reader :item_code
    xml_reader :product_name
    xml_reader :quantity
    xml_reader :price
    xml_reader :line_status, :as=>OrderInfoLineStatus
    xml_reader :warehouse_reference
    xml_reader :tracking_number
    xml_reader :line_cogs, :from=>'LineCOGS', :as=>Float
    xml_reader :unit_cogs, :from=>'UnitCOGS', :as=>Float
    xml_reader :supplier_item_code
    
        
    # OMX Status Codes
    # 0 complete?, Order cancelled at
    # 1 cancelled?
    # 2
    # 3
    # 4 Order entered processing at
    # 5
    # 6 complete?, All items shipped
    # 7 shipped?
  end

  class OrderInformationResponse < Response
    xml_name "OrderInformationResponse"
    xml_reader :order_header, :as=>OrderInfoOrderHeader
    #xml_reader :shipping_information, :as=>OrderInfoShippingInfo
    xml_reader :line_items, :as => [OrderInfoLineItem], :in=>'OrderDetail'

    xml_reader :tracking_number, :in=>'ShippingInformation/Shipment'
    xml_reader :ship_date, :in=>'ShippingInformation/Shipment',:as=>DateTime # if populated, it means all items have shipped
  end
    
end
