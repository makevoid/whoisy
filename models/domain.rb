class Domain
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  
  
  belongs_to :user, trough: :user_domain
  
end