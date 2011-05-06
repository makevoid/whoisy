class WhoisManager
  
  WHOIS = Whois::Client.new
  R = ::R
  
  def self.whois(domain)
    new(domain).whois
  end
  
  
  def initialize
  end
  
  def whois(query)
    domains = gen_domains(query)
    domains.each do |domain|
      single_whois domain
    end
  end
  
  def single_whois(query)
    begin
      if !R.sismember("domains", domain)
        result = WHOIS.query domain
        R.sadd "domains", domain
        R.zincrby "requests", domain, 1
        R.sadd("registered", domain) if result.registered?
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
  
  private
  
  def gen_domains(query)
    //
  end

end