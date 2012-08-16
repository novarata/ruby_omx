#OrderInformationRequest (OIR200)	This request type provides the ShippingInformationRequest (SIR) result for the order as a whole.

module RubyOmx

  class OrderInfoLineStatus < Node
    xml_name "LineStatus"
    #<LineStatus date="2/9/2006 2:47:00 PM" text="OK">40</LineStatus>
    xml_reader :text, :from => '@text'  # C/L means cancelled, OK with a date means processing
    xml_reader :date, :from => "@date" # reverting to string as date is invalid, cancellation date if cancelled, processing date if processing
    xml_reader :value, :from => :content, :as=>Integer
  end
  
  class OrderInfoLineItem < Node
    xml_name "LineItem"
    xml_reader :item_code
    xml_reader :product_name
    xml_reader :quantity
    xml_reader :price
    xml_reader :line_status, :as=>OrderInfoLineStatus

    xml_reader :warehouse_reference
    xml_reader :tracking_number
    
    xml_reader :shipment_number
    xml_reader :line_cogs, :from=>'LineCOGS', :as=>Float
    xml_reader :unit_cogs, :from=>'UnitCOGS', :as=>Float
    xml_reader :supplier_item_code
  end

  class OrderInfoResponse < StandardResponse
    xml_name "OrderInformationResponse"
    
    xml_reader :order_id, :in=>'OrderHeader'
    xml_reader :order_number, :in=>'OrderHeader'
    xml_reader :order_status_code, :from => '@statusCode', :in=>'OrderHeader/OrderStatus'
    xml_reader :order_status_date, :as=>DateTime, :in=>'OrderHeader'
    xml_reader :order_date, :as=>DateTime, :in=>'OrderHeader'
    
    #xml_reader :order_header, :as=>OrderInfoOrderHeader
    xml_reader :line_items, :as => [OrderInfoLineItem], :in=>'OrderDetail'
    xml_reader :customer_number, :from=>'@number', :in=>'Customer'
    xml_reader :tracking_number, :in=>'ShippingInformation/Shipment'
    xml_reader :ship_date, :in=>'ShippingInformation/Shipment',:as=>DateTime # if populated, it means all items have shipped

    def to_s
      "#{super} #{order_id} #{order_number} #{order_status_code} #{order_status_date} #{line_items.length} #{customer_number}"
    end
  end


=begin

  OMX STATUS CODES
  
  
  CustomerMemo
  Status
  0 none | 10 unread | 20 read |

  OrderAdditionalPayment
  CreditCardStatus
  0 pending | 1 charge approved | 2 charge declined | 3 charge invalid  | 7 communication failure | 9 charge in transit  | 11 authorization approved| 12 authorization declined | 13 authorization invalid | 90 cancelled |

  OrderAdditionalPayment
  CreditCardAuthStatus
  0 | 1 | 2 | 3 | 7 | 11 | 12 | 13 | 90 |
  same as above 

  OrderHeader
  CreditCardStatus
  0 | 1 | 2 | 3 | 9 | 11 | 12 | 13 |
  same as above

  OrderHeader
  CreditCardAuthStatus
  0 | 11 |
  same as above

  OrderHeader
  OrderStatus
  0 pending | 2 clearing | 3 backordered¹ | 5 on hold | 20 backordered² | 30 warehouse | 40 shipped | 50 returned  | 52 pending returned | 90 cancelled | 95 auto-cancelled | 96 voided shipment  |

  OrderLine
  LineStatus
  0 | 2 | 3 | 5 | 8 held-to-completeÂ¹| 20 | 28 held-to-completeÂ²| 30 | 40 | 50 | 52 | 90 | 95 | 96 |
  rest same as above

  OrderLine
  PreHoldLineStatus
  0 pending | 3 backordered | 8 held-to-complete¹| 10 released | 20 backordered² | 28 held-to-complete²|

  PurchaseOrderHeader
  POStatus
  10 open | 60 received | 90 cancelled |

  PurchaseOrderLine
  Status
  10 | 60 | 90 |
  same as above        

=end

end
