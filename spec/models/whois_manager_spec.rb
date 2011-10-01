# require "spec_helper"

path = File.expand_path "../../../", __FILE__

class Tld
  def self.all
    ["it", "com"]
  end
end
require 'set'


require "#{path}/models/whoiser"


describe Whoiser do
  
  before :each do
    @whoiser = Whoiser.new
  end
  
  it "should get domain" do
    Whoiser.domain("makevoid.com").should == "makevoid"
  end
  
  it "should get domain when not providing tld" do
    Whoiser.domain("makevoid").should == "makevoid"
  end
  
  it "should get tld" do
    Whoiser.tld("makevoid.com").should == "com"
  end
  
  it "should not get tld when not providing tld" do
    lambda{ Whoiser.tld("makevoid") }.should raise_error(RuntimeError)
  end
  
  it "should match one domain" do
    @whoiser.gen_domains("google.com").to_set.should == [{ name: "google", ext: "it" }, { name: "google", ext: "com"}].to_set
  end                                                         
                                                              
  it "should match one domain and accept tld options" do      
    tlds = ["it", "com", "net"]
    @whoiser.gen_domains("google.com", tlds).to_set.should == [{ name: "google", ext: "it" }, { name: "google", ext: "com"}, { name: "google", ext: "net"}].to_set
  end
end