require 'net/http'
require 'net/https'
require 'uri'
require 'cobravsmongoose'
include REXML

class Spellcheck

  USERAGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'
  PANEL = 'www.google.com'
  PATH = '/tbproxy/spell?lang=en:'

  def check_word(word)

    xml_req ='<?xml version="1.0" encoding="utf-8" ?><spellrequest textalreadyclipped="0" ignoredups="0" ignoredigits="1" ignoreallcaps="1"><text>' + word + '</text></spellrequest>'
    req = URI.escape(xml_req)
    https = Net::HTTP.new('www.google.com',443)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # GET request -> so the host can set cookies
    resp, data = https.get2(PANEL, {'User-Agent' => USERAGENT})
    cookie = resp.response['set-cookie'].split('; ')[0]

    @headers = {
      'Cookie' => cookie,
      'Referer' => 'https://'+PANEL+PATH,
      'Content-Type' => 'application/x-www-form-urlencoded',
      'User-Agent' => USERAGENT
    }

    res = https.post("/tbproxy/spell?lang=en:",xml_req,@headers)
    @result = CobraVsMongoose.xml_to_hash(res.body)
    return @result
=begin
    unless @result["spellresult"]["c"].nil?
        #puts @result["spellresult"]["c"]["@l"] #length
        puts @result["spellresult"]["c"]["$"]
        return @result["spellresult"]["c"]["$"] #strings
    else
      return nil
    end
=end
  end
end
