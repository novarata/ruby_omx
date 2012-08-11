module RubyOmx

  class MemoSubmissionRequest < Response
    def initialize(a=nil)
      return super unless a.present? # bail if no array of options has been given
      http_biz_id = a.delete(:http_biz_id)
      udi_auth_token = a.delete(:udi_auth_token)

      self.version = a[:version] ||= '1.00'
      super
      
      self.udi_parameters = []
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'UDIAuthToken', :value=>udi_auth_token})
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'HTTPBizID', :value=>http_biz_id})
    end
    
    attr_accessor :order_number, :order_id, :store_code, :raw_xml
    
    xml_name "MemoSubmissionRequest"
    xml_accessor :version, :from => '@version'
    xml_accessor :udi_parameters, :as => [RubyOmx::UDIParameter], :in => 'UDIParameter'
   
    xml_accessor :lead_number, :in=>'Memo'
    xml_accessor :customer_number, :in=>'Memo'
    xml_accessor :order_number, :in=>'Memo'
    xml_accessor :shipment_number, :in=>'Memo'
    xml_accessor :reminder_date, :in=>'Memo', :as=>DateTime # Dates are almost the same as the W3C Schema "date" type, but with a space instead of the "T" separating the date from the time.
    xml_accessor :memo_type, :in=>'Memo', :as=>Integer
    xml_accessor :memo_text, :in=>'Memo'
    xml_accessor :memo_transmission_date, :in=>'Memo', :as=>DateTime
    
  end
end
