class User
  include DataMapper::Resource
  
  property :id, Serial
  property :email, String, length: 255
  property :created_at, DateTime
  
  # has 1, :domain, { through: :domain_user }
  has n, :domains, { through: :domain_user }
end