# HypeText
The simple dirty http client library for ruby

[![Gem Version](https://badge.fury.io/rb/hypetext.png)](http://badge.fury.io/rb/hypetext)

```
$ gem install hypetext
```

###Using HypeText

```
require 'hypetext'
@client = HypeText.new
google = @client.get_by_url("http://www.google.com")
puts google[:body]
```

```
require 'hypetext'
@client = HypeText.new
post = @client.post_by_url("http://www.google.com", {:params=>{"key"=>"value"}})
puts post[:response].code
```

###Get and Post methods
```
@client.get_by_url("url string", {options hash})
@client.post_by_url("url string", {parameters hash}, {options hash})
```

##Advanced HypeText

**You can pass in a default client timeout or turn off ssl cert verification**
```
@client = HypeText.new({:timeout=>10, :ssl_verify=>false})
```
*(All requests will time out after 10 seconds and raise a HypeTextExecption::TimeoutError)*



**You can define a custom RootCA**
```
@client = HypeText.new({:rootCA=>"/my/custom/cert.ca", :ssl_verify=>true})
```


**You can add params to a get or post using a hash**
```
@client.get_by_url("http://example.com", {"key"=>"value"})
@client.post_by_url("http://example.com", {"key"=>"value"})
```



**You can add custom headers (like cookies)**
```
@client.get_by_url("http://example.com", {:parameter=>{"key"=>"value"}, :headers=>{"cookies"=>"my_cookie_string"}})
@client.get_by_url("http://example.com",{:headers=>{"cookies"=>"my_cookie_string"}})
@client.post_by_url("http://example.com", {"key"=>"value"}, {:headers=>{"cookies"=>"my_cookie_string"}})
```


**You can even override the client's timeout for a specific call**
```
@client.get_by_url("http://example.com", {:timeout=>1})
@client.get_by_url("http://example.com", {:parameter=>{"key"=>"value"}, :headers=>{"cookies"=>"my_cookie_string"}, :timeout=>30})
```
