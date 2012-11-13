module RubyOmx

  class CancellationHistoryRequest < Request

    def initialize(attrs={})
      return super unless attrs.any?
      raise MissingRequestOptions if attrs[:start_date].nil? || attrs[:end_date].nil?
      super
      self.version = attrs[:version] ||= '1.00'  		
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'StartDate', :value=>attrs[:start_date]})
      self.udi_parameters << RubyOmx::UDIParameter.new({:key=>'EndDate', :value=>attrs[:end_date] })
    end
    
    attr_accessor :start_date, :end_date
    xml_name "CancellationHistoryRequest"
  end
end
