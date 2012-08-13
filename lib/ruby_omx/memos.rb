module RubyOmx
  module Memos
    
    def build_memo_submission_request(attrs={})
		  MemoSubmissionRequest.new(attrs.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
		end
		
		def send_memo_submission_request(attrs={})
		  request = build_memo_submission_request(attrs)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      MemoSubmissionResponse.format(response)		  
		end
		alias_method :send_memo, :send_memo_submission_request

  end
end