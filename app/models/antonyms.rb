require 'net/http'
require 'cobravsmongoose'
include REXML

class Antonyms

  USERAGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'
  PANEL = 'words.bighugelabs.com'

  def get_antonyms(word)

    path = '/api/2/2cddb8d9d9c77a749568c58249717732/' + word + '/xml'

    http = Net::HTTP.new(PANEL,80)

    res = http.get(path)

    @result = CobraVsMongoose.xml_to_hash(res.body)

    return @result

  end
  

end
