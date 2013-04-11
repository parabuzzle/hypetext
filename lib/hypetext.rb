require 'net/http'
require 'net/https'
require 'timeout'

class HypeText
  
  attr_accessor :ssl_verify, :rootCA, :timeout, :ssl_verify
  attr_reader :last_call, :full_call
  
  def initialize(params={})
    # set required settings
    @rootCA = params[:rootCA] ||= nil
    @timeout = params[:timeout] ||= 0
    @ssl_verify = true
    unless params[:ssl_verify].nil?
      @ssl_verify = params[:ssl_verify]
    end
  end
  
  def get_by_url(url, p={})
    # Simple method for getting data by url
    # url is required, p = {:params=>{}, :headers={}, :timeout=0}
    # returns hash = {"response"=>NET::HTTP:RESPONSE, "url"=>string, "body"=>NET::HTTP:RESPONSE.body}
    
    # Set required settings
    params = p[:params] ||= {}
    headers = p[:headers] ||= {}
    timeout = p[:timeout] ||= @timeout
    
    # parse out uri stuff
    u = URI.parse(url)
    path = u.path
    unless params.empty?
      # Add query params if they exist
      a = []
      params.each do |k,v|
        a << "#{k}=#{v}"
      end 
      path = "#{path}?#{a.join('&')}"
    end
    
    # Setup Http
    http = Net::HTTP.new(u.host, u.port)
    if url.match(/^https/)
      # If its an ssl url.. time setup up the ssl
      http = Net::HTTP.new(u.host, 443)
      http.use_ssl = true
      http.ca_file = @rootCA
      if @ssl_verify
        # set verification
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.verify_depth = 5 # Protect against stack looping...
    end
    begin
      Timeout::timeout(timeout) do
        # Request the url
        resp, data = http.get(path, headers)
        @full_call = "#{u.host}:#{u.port}#{path}"
        @last_call = @full_call
        if resp.code.match /^301|^302/
          a = self.get_by_url(resp.header['location'])
        end
        if a
          return {:response=>a[:response], :url=>a[:url], :body=>a[:body]}
        end
        return {:response=>resp, :url=>@full_call, :body=>resp.body}
      end
    rescue Timeout::Error
      # If the call times out.. Catch it and throw an HttpClientException for better handling up the stack
      raise HypeTextException::TimeoutError.new("Get #{@full_call} Timed Out")
    end
  end
  
  def post_by_url(url, params, p={})
    # Simple method for posting data by url
    # url is required, params is a hash of post params and headers is a hash of headers
    # returns hash = {"response"=>NET::HTTP:RESPONSE, "url"=>string, "body"=>NET::HTTP:RESPONSE.body}
    headers = p[:headers] ||= {}
    timeout = p[:timeout] ||= @timeout
    if params.empty?
      raise HypeTextExcetion::MissingPostParams.new("HypeText.post_by_url(url, params) requires parameters.")
    end
    
    # Uri parsing
    u = URI.parse(url)
    path = u.path
    
    # Construct params
    a = []
    params.each do |key, value|
      a << "#{key}=#{value}"
    end
    post_params = a.join("&")
    
    # Setup Http
    if url.match(/^https/)
      # If its an ssl url.. time setup up the ssl
      http = Net::HTTP.new(u.host, u.port)
      http.use_ssl = true
      http.ca_file = @rootCA
      if @ssl_verify
        # set verification
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.verify_depth = 5 # Protect against stack looping...
    else
      http = Net::HTTP.new(u.host, u.port)
    end
    begin
      Timeout::timeout(timeout) do
        resp, data = http.post(path, post_params)
        @full_call = "#{u.host}:#{u.port}#{path}"
        @last_call = @full_call
        return {:response=>resp, :url=>@full_call, :body=>resp.body, :params=>params}
      end
    rescue Timeout::Error
      # If the call times out.. Catch it and throw an HttpClientException for better handling up the stack
      raise HypeTextException::TimeoutError.new("Post to #{@full_call} Timed Out")
    end
  end
  
end


class HypeTextException < Exception
  
  class MissingPostParams < HypeTextException
  end
  
  class TimeoutError < HypeTextException
  end
  
end