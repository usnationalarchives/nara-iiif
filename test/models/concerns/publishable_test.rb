require 'test_helper'

Temping.create :publishable_widget do
  with_columns do |t|
    t.string :status, null: false, default: "draft"
    t.datetime :published_at
    t.datetime :expired_at
  end

  include Publishable
end

class PublishableTest < ActiveSupport::TestCase

  setup do
    @record_one = PublishableWidget.create(status: "draft")
    @record_two = PublishableWidget.create(status: "published")
    @record_three = PublishableWidget.create(status: "published", published_at: Time.now.tomorrow)
    @record_four = PublishableWidget.create(status: "published", published_at: Time.now.yesterday, expired_at: Time.now)
    @record_five = PublishableWidget.create(status: "published", expired_at: Time.now.tomorrow)
  end

  test "published_at is automatically generated after initialization if it is not provided" do
    if PublishableWidget.column_names.include?("published_at")
      assert @record_one.published_at.present?
    end
  end

  test "published should return only records with a status of published and with an expired_at time that has not passed" do
    PublishableWidget.published.each do |publishable_widget|
      assert_equal "published", publishable_widget.status
      if publishable_widget.expired_at.present?
        assert publishable_widget.expired_at > Time.now
      end
    end
  end

  test "draft should return only records with a status equal to draft" do
    PublishableWidget.draft.each do |publishable_widget|
      assert_equal "draft", publishable_widget.status
    end
  end

  test "meta_status returns expected string depending on values of status, published_at, and expired_at" do
    assert_equal "draft", @record_one.meta_status
    assert_equal "published", @record_two.meta_status
    assert_equal "scheduled", @record_three.meta_status
    assert_equal "expired", @record_four.meta_status
    assert_equal "published", @record_five.meta_status
  end

  test "draft? returns true when status is equal to draft and false otherwise" do
    assert_equal true, @record_one.draft?
    assert_equal false, @record_two.draft?
  end

end
