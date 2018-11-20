require 'test_helper'

Temping.create :sluggable_widget do
  include Sluggable

  with_columns do |t|
    t.string :slug
  end
end

class SluggableTest < ActiveSupport::TestCase

  test "all instances of a Model that includes Sluggable must have a slug" do
    record = SluggableWidget.new
    refute record.save
  end

  test "all instances of a Model that includes Sluggable must have a unique slug" do
    record = SluggableWidget.create(slug: "a-slug")
    another_record = SluggableWidget.new(slug: "a-slug")
    refute another_record.save
  end

  test "all slugs must be at least 3 characters long" do
    record = SluggableWidget.new(slug: "ab")
    refute record.save
  end

  test "slugs may only include lowercase letters, numbers, and dashes, and must start with a letter" do
    # no capital letters
    record_one = SluggableWidget.new(slug: "Abc123")
    refute record_one.save

    # no special characters
    record_two = SluggableWidget.new(slug: "abc123&")
    refute record_two.save

    # cant start w/ a number
    record_three = SluggableWidget.new(slug: "1abc123")
    refute record_three.save
  end

  test "slugs cannot be equal to reserved words" do
    words = %w[
      400
      404
      406
      422
      500
      503
      504
      admin
      api
      delete
      edit
      index
      login
      logout
      page
      post
      preview
      put
      show
      view
    ]

    words.each do |word|
      new_record = SluggableWidget.new(slug: word)
      refute new_record.save
    end
  end

end
