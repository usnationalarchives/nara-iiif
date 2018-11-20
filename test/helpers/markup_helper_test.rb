require 'test_helper'

class MarkupHelperTest < ActionView::TestCase

  test "should return proper HTML when passed markdown" do
    markdown_content = "*This should be an em tag inside a paragraph*"
    assert_equal "<p><em>This should be an em tag inside a paragraph</em></p>\n",
      markdown(markdown_content)
  end

  test "should convert dumb quotes into fancy quotes" do
    test_string = '"inside quotes"'
    assert_equal "\u201cinside quotes\u201d",
      fq(test_string)

    another_test_string = "'inside quotes'"
    assert_equal "\u2018inside quotes\u2019",
      fq(another_test_string)
  end

  test "should insert a non-breaking space between the last 2 words" do
    test_string = "this is some text"
    assert_equal "this is some\u00a0text",
      uw(test_string)
  end

  test "should insert a non-breaking space between the last 3 words" do
    test_string = "this is some text"
    assert_equal "this is\u00a0some\u00a0text",
      uw(test_string, words:3)
  end

  test "should return a time ago tag" do
    test_time = DateTime.now
    assert_equal %{<time datetime="#{test_time.rfc3339}">less than a minute ago</time>},
      time_ago_tag(test_time)
  end

end
