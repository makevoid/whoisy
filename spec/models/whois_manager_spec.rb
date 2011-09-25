require "spec_helper"

describe Whoiser do
  it "should match one domain" do
    manager = Whoiser.new
    tlds = ["com", "it", "net", "org", "co.uk"]    
    manager.gen_domains("google.com").to_set.should ==  tlds.map{ |t| "google.#{t}" }.to_set
  end                                                         
                                                              
  it "should match one domain and accept tld options" do      
    manager = Whoiser.new                                
    options = {                                               
      tld: ["it", "com"]
    }
    manager.gen_domains("google.com", options).to_set.should == ["google.com", "google.it"].to_set
  end
end