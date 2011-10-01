# require "spec_helper"

path = File.expand_path "../../../", __FILE__

class Tld
  def self.all
    ["it", "com"]
  end
end
require 'set'

ENV["RACK_ENV"] = "test"
require "#{path}/config/env"

DataMapper.auto_migrate!

describe Whoiser do

  it "should do a whois" do
    whoiser = Whoiser.new
    results = whoiser.whois("makevoid.com")
    domains = []
    results.each do |domain|
      domains << { name: domain.name, ext: domain.ext, available: domain.available }
    end
    domains.should == [{ name: "makevoid", ext: "com", available: true }, { name: "makevoid", ext: "it", available: true }]
  end
  
  it "should do a whois without extension in the query" do
    whoiser = Whoiser.new
    results = whoiser.whois("makevoid")
    domains = []
    results.each do |domain|
      domains << { name: domain.name, ext: domain.ext, available: domain.available }
    end
    domains.should == [{ name: "makevoid", ext: "com", available: true }, { name: "makevoid", ext: "it", available: true }]
  end
  
end