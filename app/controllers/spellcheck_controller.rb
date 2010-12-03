class SpellcheckController < ApplicationController

  def index

  end

  def synonyms
    id = params[:text]
    if not id.nil? and not id.empty?
      syn = Synonyms.new
     @result = syn.get_synonyms(id)
    end
  end

  def antonyms

    id = params[:text]
    if not id.nil? and not id.empty?
     syn = Antonyms.new
     @result = syn.get_antonyms(id)
       @result["words"]["w"].each do |key|
         #if key["@r"].to_s.downcase == "ant"
         #else
         #end
      end
    end
  end

  def spellcheck
    id = params[:text]
    if not id.nil? and not id.empty?
      spellcheck = Spellcheck.new
      @result = spellcheck.check_word(id)
    end
  end

end


=begin
# Spell checking code
require 'net/http'
require 'net/https'
require 'uri'
require 'cobravsmongoose'
include REXML
USERAGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'
PANEL = 'www.google.com'
PATH = '/tbproxy/spell?lang=en:'
xml_req ='<?xml version="1.0" encoding="utf-8" ?><spellrequest textalreadyclipped="0" ignoredups="0" ignoredigits="1" ignoreallcaps="1"><text>inda</text></spellrequest>'
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
    unless @result["spellresult"]["c"].nil?
        puts @result["spellresult"]["c"]["@l"] #length
        puts @result["spellresult"]["c"]["$"] #strings
    end
=end