#OrderInformationRequest (OIR200)	This request type provides the ShippingInformationRequest (SIR) result for the order as a whole.

module RubyOmx

  class MemoSubmissionResponse < Response
    xml_name "MemoSubmissionResponse"
    xml_reader :success
    xml_accessor :errors, :as=>[RubyOmx::ErrorData], :in=>'ErrorData'
  end
    
end
