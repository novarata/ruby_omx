require 'test_helper'

class BaseTest < MiniTest::Unit::TestCase
  
  def test_connection
	  @connection = RubyOmx::Base.new() rescue RubyOmx::MissingAccessKey
		@connection = RubyOmx::Base.new(:udi_auth_token=>'asdfasdf') rescue RubyOmx::MissingAccessKey
  	@config = YAML.load_file( File.join(File.dirname(__FILE__), 'test_config.yml') )['test']
		@connection = RubyOmx::Base.new(@config)    
  end
  
end
