class WhoisManager
  
  WHOIS = Whois::Client.new
  
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
      WHOIS.query domain
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