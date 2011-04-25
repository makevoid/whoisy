path = File.expand_path "../../", __FILE__

require "#{path}/spec_helper"

describe "Whoisy" do
  
  it "should render the home page" do
    get '/'
    last_response.should be_ok
    last_response.body.should =~ /Whoisy/
  end
  
  it "should render the home page (webrat)" do
    visit '/'
    response.body.should =~ /Whoisy/
  end
  
  ####
  
  describe "whois" do
    it "should render results" do
      visit "/whois/makevoid.com"
      response.body.should =~ /makevoid\.com\W+is\W+registered/m
    end
    it "should render results with get params" do
      visit "/whois/?name=makevoid.com"
      response.body.should =~ /makevoid\.com\W+is\W+registered/m
    end
    it "should render results when asking for js" do
      visit "/whois/makevoid.com.js"
      domain = JSON.parse(response.body)
      domain.first["name"].should == "makevoid.com"
    end
  end
end
