module RubyOmx
    
  class Address < Response
    xml_name "Address"
    xml_accessor :address_type, :from => '@type'
    xml_accessor :title_code, :company, :firstname, :lastname, :address1, :address2, :city, :state, :phone_number, :email
    xml_accessor :zip, :from => 'ZIP'
    xml_accessor :tld, :from => 'TLD'
  end

  class LineItem < Response
    xml_name "LineItem"
    xml_accessor :line_number, :from => '@lineNumber'
    xml_accessor :item_code
    xml_accessor :quantity, :as => Integer
    xml_accessor :unit_price, :as => Float
  end
    
  class CustomField < Response
    xml_name 'Field'
    xml_accessor :field_id, :from => '@fieldID'
    xml_accessor :line_number, :from => '@lineNumber'
    xml_accessor :value, :from => :content
  end
    
  class Flag < Response
    xml_name 'Flag'
    xml_accessor :name, :from => '@name'
    xml_accessor :value, :from => :content      
  end

  class UDOARequest < Response
    def initialize(a=nil)
      if !a.nil?
        http_biz_id = a.delete(:http_biz_id)
        udi_auth_token = a.delete(:udi_auth_token)
        
  		  required_fields = [:keycode, :queue_flag, :verify_flag, :order_date, :order_id, :bill_to, :line_items, :method_code]
  		  raise MissingOrderOptions if required_fields.any? { |option| a[option].nil? }
        super
        self.version = a[:version] ||= '2.00'
        self.payment_type = a[:payment_type] ||= '6'  #6 for open invoice
        self.origin_type = a[:origin_type] ||= '2'    # 2 = phone order, 3 = internet order      
        self.udi_parameters = []
        self.udi_parameters << UDIParameter.new({:key=>'UDIAuthToken', :value=>udi_auth_token})
        self.udi_parameters << UDIParameter.new({:key=>'HTTPBizID', :value=>http_biz_id})
        self.udi_parameters << UDIParameter.new({:key=>'Keycode', :value=>a[:keycode]})
        self.udi_parameters << UDIParameter.new({:key=>'VerifyFlag', :value=>a[:verify_flag] ||= 'True' }) # Determines whether a successful order should be saved, or only verified/calculated. When set to "True", OrderMotion will behave as if the order was placed, but not return an Order Number in the response.
        self.udi_parameters << UDIParameter.new({:key=>'QueueFlag', :value=>a[:queue_flag] ||= 'False' })  # Determines whether any orders with errors will be stored in the OrderMotion "Outside Order Queue",  to be corrected by an OrderMotion user before resubmission. If set to "True", almost all orders will be   accepted by OrderMotion, but additional order information will only be returned in the response if the order   is successfully placed. Otherwise, any order with any error (eg invalid ZIP code) will be rejected.
        self.udi_parameters << UDIParameter.new({:key=>'Vendor', :value=>a[:vendor] }) if !a[:vendor].nil?           
        self.bill_to = Address.new(a[:bill_to])
        self.ship_to = Address.new(a[:ship_to])
      
        i = 0
        self.line_items = a[:line_items].collect { |h|
          i+=1
          h[:line_number] = h[:line_number] ||= i  # Provide line numbers if they are omitted
          LineItem.new(h)
        }
        
        self.custom_fields = a[:custom_fields].collect { |h| CustomField.new(h) } if !a[:custom_fields].nil?
        self.flags = a[:flags].collect { |h| Flag.new(h) } if !a[:flags].nil?
      else
        super
      end
    end
      
    attr_accessor :raw_xml, :keycode, :queue_flag, :verify_flag, :vendor
      
    xml_name "UDOARequest"
    xml_accessor :version, :from => '@version'
    xml_accessor :udi_parameters, :as => [RubyOmx::UDIParameter], :in => 'UDIParameter'
    xml_accessor :order_date, :in => 'Header', :as => DateTime  # Dates are almost the same as the W3C Schema "date" type, but with a space instead of the "T" separating the date from the time.
    xml_accessor :order_id, :in => 'Header', :from => 'OrderID'
    xml_accessor :origin_type, :in => 'Header'
    xml_accessor :store_code, :in => 'Header'
    xml_accessor :bill_to, :as => Address, :in => 'Customer'
    xml_accessor :flags, :as => [Flag], :in => 'Customer/FlagData'
    xml_accessor :ship_to, :as => Address, :in => 'ShippingInformation'

    xml_accessor :method_code, :in => 'ShippingInformation', :as => Integer
    xml_accessor :shipping_amount, :in => 'ShippingInformation', :as => Float
    xml_accessor :handling_amount, :in => 'ShippingInformation', :as => Float
    xml_accessor :special_instructions, :in => 'ShippingInformation'
    xml_accessor :gift_wrapping, :in => 'ShippingInformation'
    xml_accessor :gift_message, :in => 'ShippingInformation'            

    xml_accessor :payment_type, :in => 'Payment', :from => '@type'
  	xml_accessor :card_number, :in => 'Payment'
  	xml_accessor :card_verification, :in => 'Payment'
  	xml_accessor :card_exp_date_month, :in => 'Payment'
  	xml_accessor :card_exp_date_year, :in => 'Payment'
    xml_accessor :card_status, :in => 'Payment'
  	xml_accessor :card_auth_code, :in => 'Payment' 	    	
  	xml_accessor :card_transaction_id, :from => 'CardTransactionID', :in => 'Payment'

    xml_accessor :line_items, :as => [LineItem], :in => 'OrderDetail'
    xml_accessor :custom_fields, :as => [CustomField], :in => 'CustomFields/Report'
    xml_accessor :total_amount, :in => 'Check'  
  end
end
