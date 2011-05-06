class WhoisManager
  
  WHOIS = Whois::Client.new
  
  R = Redis.new
  
  def self.whois(domain)
    new(domain).whois
  end
  
  
  def initialize
  end
  
  def whois(query)
    domains = gen_domains(query)
    domains.map do |domain|
      single_whois domain
    end
  end
  
  def single_whois(domain)
    begin
      if !R.sismember("domains", domain)
        result = WHOIS.query domain
        R.sadd "domains", domain
        #R.zincrby "requests", domain, 1
        R.sadd("registered", domain) if result.registered?
        #TODO: salvare anche i dettagli del whois
        result
      else
        nil 
      end
    rescue Whois::ServerNotFound
      nil
    rescue Timeout::Error
      # FIME: retry async, cache
      Thread.new {
        whois(domain)
      }
      nil 
    end
  end
  
  #private
  
  DEFAULT_TLD = R.smembers "tld"
  
  def gen_domains(query, options={tld: nil})
    tld = DEFAULT_TLD
    tld = options[:tld] unless options[:tld].nil?
    first = query.split(".")[0..-2].join(".")
    tld = tld.map do |tl|
      "#{first}.#{tl}"
    end
    tld
  end

end