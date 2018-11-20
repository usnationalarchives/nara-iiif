require "test_helper"

class BadRequestHandlingTest < ActionDispatch::IntegrationTest

  test "should get an HTTP 400 with a poorly encoded UTF-8 request" do
    get "#{root_url}?%28t%B3odei%29"
    assert_response :bad_request
  end

end
