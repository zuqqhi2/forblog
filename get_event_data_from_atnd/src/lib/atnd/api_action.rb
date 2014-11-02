module Atnd
  
  class APIAction
    require 'net/http'
    require 'uri'
    require 'json'
    require 'logger'

    def initialize(url,keyword,count=100)
      raise ArgumentError, 'irregular url' if (!/^http(s)?:\/\/[a-z0-9.\/]+$/.match(url))
      #raise ArgumentError, 'irregular url' if (!/http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?/.match(url))
      raise ArgumentError, 'irregular count' if (!count.is_a?(Numeric) or count < 0 or count > 100)

      @url     = url
      @keyword = keyword
      @count   = count
      @logger  = Logger.new(STDOUT)
    end

    # Get json event data from ATND web API
    def get_event_json(open_timeout, read_timeout)
      raise ArgumentError, 'missing argument open_timeout' if !defined? open_timeout
      raise ArgumentError, 'missing argument read_timeout' if !defined? read_timeout

      access_url  = @url
      access_url += "?keyword_or=" + @keyword if !@keyword.empty?
      access_url += "&count=" + @count.to_s + "&format=json"
      
      uri = URI.parse(access_url)
      begin
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.open_timeout = open_timeout
          http.read_timeout = read_timeout
          http.get(uri.request_uri)
        end

        case response
          when Net::HTTPSuccess
            json = response.body
            return JSON.parse(json)
          when Net::HTTPRedirection
            location = response['location']
            @logger.error("redirected to #{location}")
            return nil
          else
            @logger.error([uri.to_s, response.value].join(" : "))
            return nil
        end
      rescue => ex
        @logger.fatal([uri.to_s, ex.class, ex].join(" : "))
        return nil
      end
    end
  end
end
  
