require 'test_helper'

class ServiceHelperTest < ActionView::TestCase

  test "should build a uri w/ proper query params" do
    base_uri = "http://www.test.com"
    params = {
      param1: "param_1_value",
      param2: "param_2_value",
      param3: "param_3_value",
    }

    assert_equal "http://www.test.com?param1=param_1_value&amp;param2=param_2_value&amp;param3=param_3_value",
      service_uri(base_uri, params)
  end

  test "should build a proper twitter intent uri" do
    options = {
      hashtags: "hashtags_value",
      related: "related_value",
      text: "text_value",
      url: "url_value",
      via: "via_value"
    }

    assert_equal "https://twitter.com/intent/tweet/?dnt=true&amp;hashtags=hashtags_value&amp;related=related_value&amp;text=text_value&amp;url=url_value&amp;via=via_value",
      twitter_intent_uri(options)
  end

  test "should build a proper facebook intent uri" do
    options = {
      u: "u_value"
    }

    assert_equal "https://www.facebook.com/sharer/sharer.php?u=u_value",
      facebook_intent_uri(options)
  end

  test "should build a proper pinterest intent uri" do
    options = {
      description: "description_value",
      media: "media_value",
      url: "url_value"
    }

    assert_equal "https://pinterest.com/pin/create/button/?description=description_value&amp;media=media_value&amp;url=url_value",
      pinterest_intent_uri(options)
  end

  # Stub current_url for these tests
  def current_url
    "https://www.example.com/some/path"
  end

  # Stub url_for for these tests
  def url_for(options)
    "/some/path"
  end

end
