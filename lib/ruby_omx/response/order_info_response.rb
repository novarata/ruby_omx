#OrderInformationRequest (OIR200)	This request type provides the ShippingInformationRequest (SIR) result for the order as a whole.

module RubyOmx

  class OrderInfoResponse < StandardResponse
    xml_name "OrderInformationResponse"
    
    xml_reader :order_id, :in=>'OrderHeader', :from=>'OrderID'
    xml_reader :order_number, :in=>'OrderHeader'
    xml_reader :order_status_code, :from => '@statusCode', :in=>'OrderHeader/OrderStatus'
    xml_reader :order_status_date, :as=>DateTime, :in=>'OrderHeader'
    xml_reader :order_date, :as=>DateTime, :in=>'OrderHeader'
    xml_reader :keyed_date, :as=>DateTime, :in=>'OrderHeader'
    xml_reader :total_amount, :as => Float, :in=>'OrderHeader'
    xml_reader :keycode, :in=>'OrderHeader'

    xml_reader :bill_to, :as => Address, :in => 'Customer'
    xml_reader :ship_to, :as => Address, :in => 'ShippingInformation'

    xml_reader :method_code, :in => 'ShippingInformation/Method', :from=>'@code', :as => Integer
    xml_reader :shipping_amount, :in => 'ShippingInformation', :as => Float
    xml_reader :handling_amount, :in => 'ShippingInformation', :as => Float

    xml_reader :line_items, :as => [LineItem], :in => 'OrderDetail'    
    
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
