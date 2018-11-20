require 'test_helper'

Temping.create :designateable_widget do
  include Designateable

  with_columns do |t|
    t.boolean :designated, null: false, default: false
    t.datetime :expired_at
  end
end

class DesignateableTest < ActiveSupport::TestCase

  setup do
    @record_one = DesignateableWidget.create
    @record_two = DesignateableWidget.create
    @record_three = DesignateableWidget.create(designated: true)
  end

  test "new instances of a Model that includes Designateable have a default designated value of false unless otherwise specified" do
    assert_equal false, @record_one.designated
    assert_equal false, @record_two.designated
    assert_equal true, @record_three.designated
  end

  test "calling designated on a Designateable class will return an instance of the only designated record of that class" do
    the_one = DesignateableWidget.designated
    assert_equal @record_three, the_one
  end

  test "if the designated record's expired_at value is less than Time.current then no record of it's class is considered designated" do
    assert_equal @record_three, DesignateableWidget.designated
    @record_three.expired_at = 1.day.ago
    @record_three.save
    assert_nil DesignateableWidget.designated
  end

  test "calling undesignate! on an instance of a designated record will set the record's designated value to false, leaving no records of it's class designated" do
    assert_equal true, @record_three.designated
    @record_three.undesignate!
    assert_equal false, @record_three.designated
    assert_nil DesignateableWidget.designated
  end

  test "there can be only one" do
    assert_equal true, @record_three.designated
    @record_two.designate!
    assert_equal @record_two, DesignateableWidget.designated
    assert_equal 1, DesignateableWidget.where(designated: true).count
  end

end
