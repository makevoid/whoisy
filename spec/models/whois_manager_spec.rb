require "spec_helper"

describe WhoisManager do
  it "should match one domain" do
    manager = WhoisManager.new
    tlds = ["com", "it", "net", "org", "uk"]    
    manager.gen_domains("google.com").to_set.should ==  tlds.map{ |t| "google.#{t}" }.to_set
  end                                                         
                                                              
  it "should match one domain and accept tld options" do      
    manager = WhoisManager.new                                
    options = {                                               
      tld: ["it", "com"]
    }
    manager.gen_domains("google.com", options).to_set.should == ["google.com", "google.it"].to_set
  end
end