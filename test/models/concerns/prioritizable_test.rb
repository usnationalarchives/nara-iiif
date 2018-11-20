require 'test_helper'

Temping.create :prioritizable_widget do
  include Prioritizable

  with_columns do |t|
    t.integer :priority, null: false
  end
end

class PrioritizableTest < ActiveSupport::TestCase

  setup do
    @record_one = PrioritizableWidget.create
    @record_two = PrioritizableWidget.create
    @record_three = PrioritizableWidget.create
  end

  test "priority must be unique for a given Model" do
    record_one = PrioritizableWidget.new(priority: 1)
    assert record_one.save

    record_two = PrioritizableWidget.new(priority: 1)
    refute record_two.save
  end

  test "priority is equal to 2 on the first record of a model, subsequent records are equal to the maximum priority of any record of the same type plus 2" do
    assert_equal 2, @record_one.priority
    assert_equal 4, @record_two.priority
    assert_equal 6, @record_three.priority
  end

  test "should return an array of all the records by ascending priority" do
    records = PrioritizableWidget.prioritized
    assert_equal [@record_one, @record_two, @record_three],
      PrioritizableWidget.prioritized
  end

  test "returns expected priority placement string" do
    assert_equal "top", @record_one.priority_placement
    assert_equal "middle", @record_two.priority_placement
    assert_equal "bottom", @record_three.priority_placement
    @record_two.destroy
    @record_three.destroy
    assert_equal "lonely", @record_one.priority_placement
  end

  test "should move the record down in priority" do
    records = PrioritizableWidget.prioritized
    assert_equal [@record_one, @record_two, @record_three],
      PrioritizableWidget.prioritized

    @record_one.move_down!

    assert_equal [@record_two, @record_one, @record_three],
      PrioritizableWidget.prioritized
  end

  test "should move the record up in priority" do
    records = PrioritizableWidget.prioritized
    assert_equal [@record_one, @record_two, @record_three],
      PrioritizableWidget.prioritized

    @record_three.move_up!

    assert_equal [@record_one, @record_three, @record_two],
      PrioritizableWidget.prioritized
  end

end
