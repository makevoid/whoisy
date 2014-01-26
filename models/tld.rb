class Tld

  # TLDS = ["com", "net", "org", "it", "co.uk"]
  #TLDS = ["com", "net", "org", "it"]
  TLDS = ["com", "net", "it"] # TODO: check org for parse error
  # TLDS = ["com", "it"]

  def self.all
    TLDS
  end

end