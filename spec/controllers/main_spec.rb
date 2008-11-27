require File.dirname(__FILE__) + '/../spec_helper'

describe "Forumtastic::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:Forumtastic) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(Forumtastic::Main, :index)
    controller.slice.should == Forumtastic
    controller.slice.should == Forumtastic::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(Forumtastic::Main, :index)
    controller.status.should == 200
    controller.body.should contain('Forumtastic')
  end
  
  it "should work with the default route" do
    controller = get("/forumtastic/main/index")
    controller.should be_kind_of(Forumtastic::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/forumtastic/index.html")
    controller.should be_kind_of(Forumtastic::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(Forumtastic::Main, 'index')
    
    url = controller.slice_url(:forumtastic_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/forumtastic/main/show.html"
    controller.slice_slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.slice_url(:forumtastic_index, :format => 'html')
    url.should == "/forumtastic/index.html"
    controller.slice_slice_url(:index, :format => 'html').should == url
    
    url = controller.slice_url(:forumtastic_home)
    url.should == "/forumtastic/"
    controller.slice_slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(Forumtastic::Main, :index)
    controller.public_path_for(:image).should == "/slices/forumtastic/images"
    controller.public_path_for(:javascript).should == "/slices/forumtastic/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/forumtastic/stylesheets"
    
    controller.image_path.should == "/slices/forumtastic/images"
    controller.javascript_path.should == "/slices/forumtastic/javascripts"
    controller.stylesheet_path.should == "/slices/forumtastic/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    Forumtastic::Main._template_root.should == Forumtastic.dir_for(:view)
    Forumtastic::Main._template_root.should == Forumtastic::Application._template_root
  end

end