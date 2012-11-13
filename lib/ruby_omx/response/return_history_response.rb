module RubyOmx

  class ReturnHistoryLineItem < Node
    xml_name "LineItem"
    xml_reader :item_code
    xml_reader :line_number, :from=>"@lineNumber"    
    xml_reader :ordered_quantity, :as=>Integer      #	<OrderedQuantity>4</OrderedQuantity>
  	xml_reader :return_quantity, :as=>Integer       #	<ReturnQuantity>1</ReturnQuantity>
  	xml_reader :return_amount, :as=>Float           #	<ReturnAmount>3.00</ReturnAmount>
  	xml_reader :return_tax_amount, :as=>Float       # <ReturnTaxAmount>0.00</ReturnTaxAmount>
  	xml_reader :return_reason   	                  # <ReturnReason code="BADE" type="Replacement">Exchange - Add Inv</ReturnReason>
  end

  class ReturnHistoryItem < Node
    xml_name "Return"
    xml_reader :return_id, :from=>"@returnID"
    xml_reader :return_type, :from=>"@type"
    xml_reader :return_date, :as=>DateTime
    xml_reader :return_amount, :as=>Float
    xml_reader :return_tax_amount, :as=>Float
    xml_reader :line_items, :as=>[ReturnHistoryLineItem], :in=>"LineDetail"    
  end

  class ReturnHistoryOrder < Node
    xml_name "Order"
    xml_reader :order_number, :from=>"@orderNumber"
    xml_reader :order_id, :in=>"Header", :from=>"OrderID"
    xml_reader :store_code, :in=>"Header"
    xml_reader :returns, :as => [ReturnHistoryItem], :in=>"ReturnDetail"
  end

  class ReturnHistoryResponse < StandardResponse
    xml_name "ReturnHistoryResponse"
    xml_reader :orders, :as => [ReturnHistoryOrder]    
  end

	#<Order orderNumber="12992">
	#	<Header>
	#		<OrderID/>
	#		<StoreCode/>
	#	</Header>
	#	<ReturnDetail>
	#		<Return returnID="1" type="Return">
	#			<ReturnDate>2006-02-16 12:16:00</ReturnDate>
	#			<ReturnAmount>3.00</ReturnAmount>
	#			<ReturnTaxAmount>0.00</ReturnTaxAmount>
	#			<LineDetail>
	#				<LineItem lineNumber="3">
	#					<ItemCode>1112</ItemCode>
	#					<OrderedQuantity>4</OrderedQuantity>
	#					<ReturnQuantity>1</ReturnQuantity>
	#					<ReturnAmount>3.00</ReturnAmount>
	#					<ReturnTaxAmount>0.00</ReturnTaxAmount>
	#					<ReturnReason code="BADE" type="Replacement">Exchange - Add Inv</ReturnReason>
	#				</LineItem>
	#			</LineDetail>
	#		</Return>
	#	</ReturnDetail>
	#</Order>

end
