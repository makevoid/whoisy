class User
  include DataMapper::Resource
  
  property :id, Serial
  property :email, String, length: 255
  property :created_at, DateTime
  
  
  belongs_to :domain, trough: :user_domain
  
end