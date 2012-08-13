module RubyOmx

  class SmartReportField < Node
    xml_name "Field"
    xml_reader :id, :from=>'@fieldID'
    xml_reader :value, :from=>:content
  end
  
  class SmartReportRow < Node
    xml_name "Row"
    xml_reader :fields, :as=>[SmartReportField]
    #1 Order Number
    #2 Alt ID
    #3 Product SKU
    #4 Product Name
    #5 Quantity
    #6 Price
    #7 Customer Number
    #8 Customer Name
    #10 Shipping Type
    #11 Supplier Id
    #12 Supplier Name
  end

  class SmartReportResponse < Response
    xml_name "SmartReportResultXml"
    xml_reader :rows, :as=>[SmartReportRow], :in=>'Detail'
  end
  
end