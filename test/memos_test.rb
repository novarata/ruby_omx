require 'test_helper'

class MemosTest < MiniTest::Unit::TestCase
  def setup
		@config = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )['test']
		@connection = RubyOmx::Base.new(@config)		
  end
  
  def test_request_from_xml
    request = RubyOmx::MemoSubmissionRequest.format(xml_for('MemoSubmissionRequest(1.00)',200))
    assert_equal '1.00', request.version
    assert_equal '949538', request.order_number
    assert_equal 'Test Memo', request.memo_text
    assert_equal DateTime.parse('2003-04-01 22:15:10'), request.reminder_date
    assert_equal DateTime.parse('2003-03-01 22:15:10'), request.memo_transmission_date
  end

  def test_send_memo_submission_request
  	@connection.stubs(:post).returns(xml_for('MemoSubmissionResponse(1.00)',200))
  	request = MemoSubmissionRequest.new
  	  	
  	memo_data = { :order_number => '1834534568',
                  :memo_text=>'test text',
                  :reminder_date=>'2012-08-13 00:00:00',
                  :memo_transmission_date=>'2012-08-11 17:05:16' }

	  r = @connection.build_memo_submission_request(memo_data)
    assert_instance_of String, r.to_xml.to_s
		
  	response = @connection.send_memo_submission_request(memo_data)
  	assert_kind_of MemoSubmissionResponse, response
  	assert_equal '1', response.success
  	assert_kind_of Hash, response.as_hash

  	response = @connection.send_memo_submission_request(memo_data.merge({:raw_xml => true}))
  	assert_kind_of Net::HTTPOK, response
	
  	# old alias should still work
  	response = @connection.send_memo(memo_data)		
  	assert_kind_of MemoSubmissionResponse, response
  end
end