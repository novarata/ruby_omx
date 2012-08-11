module RubyOmx
  module Memos
    
    def build_memo_submission_request(params={})
		  MemoSubmissionRequest.new(params.merge({:udi_auth_token=>@udi_auth_token, :http_biz_id=>@http_biz_id}))
		end
		
		def send_memo_submission_request(params={})
		  request = build_memo_submission_request(params)
      response = post(request.to_xml.to_s)
      return response if request.raw_xml==true || request.raw_xml==1
      MemoSubmissionResponse.format(response)		  
		end
		alias_method :send_memo, :send_memo_submission_request

  end
end