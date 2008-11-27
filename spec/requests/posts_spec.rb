require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/posts" do
  before(:each) do
    @response = request("/posts")
  end
end