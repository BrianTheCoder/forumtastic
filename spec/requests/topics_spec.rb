require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/topics" do
  before(:each) do
    @response = request("/topics")
  end
  
  it 'should be successful' do
    @response.should be_successful
  end
end