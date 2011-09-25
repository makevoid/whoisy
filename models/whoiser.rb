class Whoiser
  
  WHOIS = Whois::Client.new
  
  def self.whois(domain)
    new(domain).whois
  end
  
  def whois(query)
    domains = gen_domains(query)
    domains.map do |domain|
      single_whois domain
    end
  end
  
  def single_whois(domain)
    begin
      do_single_whois(domain)
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
  
  include Mhash
  
  def do_single_whois(domain)
    result = WHOIS.query domain
    to_mhash( { name: domain, available: result.available?, response: result } )
  end
  
  #private
  
  def gen_domains(query, options={tld: nil})
    tld = Tld.all
    tld = options[:tld] unless options[:tld].nil?
    first = query.split(".")[0..-2].join(".")
    tld = tld.map do |tl|
      "#{first}.#{tl}"
    end
    tld
  end

end