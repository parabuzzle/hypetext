class TestHypeText < Test::Unit::TestCase
  
  def setup
    @client = HypeText.new
    @tweaked = HypeText.new({:timeout=>10, :ssl_verify=>false})
  end
  
  def teardown
  end
  
  def test_client
    assert_equal @client.timeout, 0
    assert @client.ssl_verify
    assert_equal @tweaked.timeout, 10
    assert !@tweaked.ssl_verify
  end
  
  def test_get_by_url
    google = @tweaked.get_by_url("http://www.google.com/")
    google_redirect_follow = @tweaked.get_by_url("http://google.com/")
    assert_equal google[:url], "www.google.com:80/"
    assert_equal google_redirect_follow[:url], "www.google.com:80/"
    assert google[:body].match /Lucky/i
  end
  
  def test_post_by_url
    #TODO..
  end
  
end