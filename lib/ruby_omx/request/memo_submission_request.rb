module RubyOmx

  class MemoSubmissionRequest < Request
    def initialize(a={})
      super
      self.version = a[:version] ||= '1.00'
    end
    
    attr_accessor :order_number, :order_id, :store_code
    
    xml_name "MemoSubmissionRequest"
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
