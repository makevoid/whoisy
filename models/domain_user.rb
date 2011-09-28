class DomainUser 
  include DataMapper::Resource
  
  property :id, Serial
  
  belongs_to :user
  belongs_to :domain
end

UserDomain = DomainUser