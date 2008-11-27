require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/sessions" do
  before(:each) do
    @response = request("/sessions")
  end
end