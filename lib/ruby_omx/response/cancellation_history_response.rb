module RubyOmx

  class CancellationHistoryLineItem < Node
    xml_name "LineItem"
    xml_reader :cancellation_date, :as=>DateTime
    xml_reader :line_number, :from => '@lineNumber'
    xml_reader :item_code
    xml_reader :quantity, :as=>Integer      # <Quantity>1</Quantity>
  	xml_reader :price, :as=>Float           # <Price type="U">4.95</Price>
    xml_reader :tax, :as=>Float 	          #	<Tax percent="8.75">0.43</Tax>
  	xml_reader :total_amount, :as=>Float    #	<TotalAmount>5.38</TotalAmount>
    xml_reader :sh, :as=>Float, :from=>"SH"
    xml_reader :sh_tax, :as=>Float, :from=>"SHTax"
  end

  class CancellationHistoryOrder < Node
    xml_name "Order"
    xml_reader :order_number, :from=>"@orderNumber"
    xml_reader :order_id, :in=>"Header", :from=>"OrderID"
    xml_reader :store_code, :in=>"Header"
    xml_reader :line_items, :as => [CancellationHistoryLineItem], :in=>"OrderDetail"
  end

  class CancellationHistoryResponse < StandardResponse
    xml_name "CancellationHistoryResponse>"
    xml_reader :orders, :as => [CancellationHistoryOrder]    
  end

	#<Order orderNumber="18602">
	#	<Header>
	#		<OrderID/>
	#		<StoreCode/>
	#	</Header>
	#	<OrderDetail>
	#		<LineItem lineNumber="4">
	#			<CancellationDate>2005-08-04 10:46:00</CancellationDate>
	#			<ItemCode>SUMTRACOFFEE</ItemCode>
	#			<Quantity>1</Quantity>
	#			<Price type="U">4.95</Price>
	#			<Tax percent="8.75">0.43</Tax>
	#			<TotalAmount>5.38</TotalAmount>
	#			<SH>0</SH>
	#			<Info/>
	#			<SHTax>0</SHTax>
	#		</LineItem>
	#	</OrderDetail>
	#</Order>

end
