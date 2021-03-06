class Domain
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, length: 50
  property :ext, String, length: 5, index: true
  property :updated_at, DateTime
  property :whois_count, Integer, default: 0

  has n, :results
  
  before :save do
    self.whois_count = self.whois_count+1
  end
  
  has 1, :user, { through: :domain_user }
  
  def self.cacheds(name, tlds=Tld.all)
    all(name: name, ext: tlds, :updated_at.lte => Time.now, :updated_at.gte => Time.now - 3600 )
  end
end