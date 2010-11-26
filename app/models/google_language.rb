require 'typhoeus'
require 'json'
require 'uri'

#
# http://code.google.com/apis/ajaxlanguage/documentation
#
class GoogleLanguageError < RuntimeError; end

class GoogleLanguage
  include Typhoeus

  URL         = 'http://ajax.googleapis.com/ajax/services/language/translate'
  API_VERSION = '1.0'
  DEBUG       = false
  SUCCESS_HANDLER = lambda do |response|
    puts response.inspect if DEBUG

    r = JSON.parse(response.body)
    d = r['responseData']
    s = r['responseStatus']
    raise GoogleLanguageError, r['responseDetails'] if d.nil?
    
    d['translatedText']
  end
  ERROR_HANDLER = lambda do |response| 
    raise "Error: #{response.code}. Body #{response.body}"
  end

  remote_defaults :on_success      => SUCCESS_HANDLER,
                  :on_failure      => ERROR_HANDLER,
                  :cache_responses => 180
  define_remote_method :get_translate,
                       :base_uri => URL,
                       :headers => { "User-Agent" => "http://aktagon.com/projects/ruby/google-language" }

  class << self
    def url(text, options = {})
      "#{URL}?#{to_uri('',options)}"
    end

    def translate(text, options = {})
      get_translate(:params => to_params(text, options)) 
    end

    protected
      def to_uri(text, options)
        to_params(text, options).map {|key, val| "#{key}=#{val}" }.join("&")
      end

      def to_params(text, options)
        from = options.delete(:from)
        to = options.delete(:to)
        options.merge!(
          :q        => text, 
          :langpair => "#{from}|#{to}",
          :v        => API_VERSION
        )
      end
  end

end
