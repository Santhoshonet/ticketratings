require 'net/http'
require 'cobravsmongoose'
include REXML

class Synonyms

  USERAGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'
  PANEL = 'www.abbreviations.com'

  def get_synonyms(word)

    path = '/services/v1/syno.aspx?tokenid=tk1369&word=' + word

    http = Net::HTTP.new(PANEL,80)

    res = http.get(path)

    @result = CobraVsMongoose.xml_to_hash(res.body)
    
    return @result
    
  end

end
