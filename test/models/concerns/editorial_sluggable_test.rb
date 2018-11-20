require 'test_helper'

Temping.create :editorial_sluggable_widget do
  include EditorialSluggable

  with_columns do |t|
    t.string :title
  end
end

class EditorialSluggableTest < ActiveSupport::TestCase

  test "should build an editorial slug based on the title attribute of the record" do
    record = EditorialSluggableWidget.create(id: 1, title: "Test Title")
    assert_equal "test-title-1",
      record.editorial_slug
  end

  test "should return the proper record when finding by editorial slug" do
    new_record = EditorialSluggableWidget.create(id: 2, title: "Test Title")
    record = EditorialSluggableWidget.find_by_editorial_slug("test-title-2")
    assert_equal new_record, record
  end

end
