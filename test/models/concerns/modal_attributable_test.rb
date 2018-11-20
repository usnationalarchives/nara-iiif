require 'test_helper'

Temping.create :modal_attributable_widget do
  include ModalAttributable

  modal_attribute :status, {
    published: "Published",
    draft: "Draft",
    retired: "Retired"
  }

  with_columns do |t|
    t.string :status, null: false, default: "draft"
  end
end

class ModalAttributableTest < ActiveSupport::TestCase

  test "should return the original hash of attributes" do
    values = ModalAttributableWidget.status_values
    expected_hash = {"published"=>"Published", "draft"=>"Draft", "retired"=>"Retired"}
    assert_equal expected_hash, values
  end

  test "should return the human-readable string for the record's status" do
    record = ModalAttributableWidget.create(status: "draft")
    assert_equal "Draft", record.status_string
  end

  test "should return proper boolean values when checking the status of a record" do
    record = ModalAttributableWidget.create(status: "published")
    assert_equal false, record.status.draft?
    assert_equal false, record.status.retired?
    assert_equal true, record.status.published?
  end

  test "should assign a new status to a record" do
    record = ModalAttributableWidget.create(status: "draft")
    assert_equal "draft", record.status
    record.status = :published
    assert_equal "published", record.status
  end

  test "status can only be equal to one of the keys defined by modal_attribute" do
    record = ModalAttributableWidget.create(status: "wrong_key")
    refute record.save
  end

end
