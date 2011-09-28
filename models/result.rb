class Result
  include DataMapper::Resource
  
  property :id, Serial
  
  belongs_to :domain
  
  property :available, Boolean
  attr_accessor :name
  attr_accessor :ext  
  attr_accessor :response_obj
  property :response, Text# json_blob  
  property :response_raw, Text
  
  property :updated_at, DateTime

  before :create do
    self.response = JSON.parse(self.response_obj) if self.response_obj
  end

  before :save do
    self.updated_at = DateTime.now
    self.domain.updated_at = DateTime.now
    self.domain.save
  end

  belongs_to :domain

end