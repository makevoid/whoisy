class Whoiser
  
  WHOIS = Whois::Client.new
  
  def self.whois(domain)
    new(domain).whois
  end
  
  def self.tld(domain)
    domain.split(".")[-1]
  end
  
  def self.domain(query)
    query.split(".")[0..-2].join(".")
  end
  
  def whois(query)
    tlds = Tld.all
    name = Whoiser.domain(query)
    if Whoiser.cached?(name, tlds)
      from_cache(name, tlds)
    else
      domains = gen_domains(name, tlds)
      cache( 
        domains.map do |domain|
          single_whois domain
        end 
      )
    end
  end
  
  
  def self.cached?(name, tlds)
    domains = Domain.all(name: name, ext: tlds, :updated_at.lte => Time.now, :updated_at.gte => Time.now - 3600 ).count
    domains == tlds.size
  end
  
  private
  
  def cache(results)
    # Result.transaction do 
      results.each do |res|
        domain = Domain.first_or_create(name: res.name, ext: res.ext)
        # unless domain.saved?
        #   puts "Errors saving 'domain':"
        #   puts domain.inspect
        # end
        result = { domain: domain, available: res.available, response_raw: res.response }
        re = Result.first_or_create result
        # unless re.saved?
        #   puts "Errors saving 'result':"
        #   puts re.errors.inspect
        # end
      end
    # end
    results 
  end
  
  def from_cache(name, tlds)
    Domain.all(name: name, ext: tlds).map do |dom| 
      to_mhash({ name: dom.name, ext: dom.ext, available: dom.results.last.available })
    end
  end
  
  def single_whois(domain)
    res = do_single_whois(domain)
    # rescue exceptions properly
    # Whois::ServerNotFound
    # Timeout::Error
  end
  
  include Mhash
  
  def do_single_whois(domain)
    result = WHOIS.query "#{domain.name}.#{domain.ext}"
    to_mhash( domain.merge({ available: result.available?, response: result }) )
  end
  
  def gen_domains(name, tlds)
    tlds.map do |tld|
      to_mhash({ name: name,  ext: tld })
    end
  end


end