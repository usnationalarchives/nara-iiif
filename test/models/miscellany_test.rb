require 'test_helper'

class MiscellanyTest < ActiveSupport::TestCase

  test "should not save miscellany without the required fields" do
    misc = Miscellany.new
    refute misc.save
  end

  test "should save when provided all required attributes" do
    misc = Miscellany.new(key: "test_key", name: "test_name", description: "test_description", value: "test_value")
    assert misc.save
  end

  test "should not allow miscellany items with matching keys" do
    misc = Miscellany.new(key: "test_key", name: "test_name", description: "test_description", value: "test_value")
    assert misc.save

    another_misc = Miscellany.new(key: "test_key", name: "another_test_name", description: "another_test_description", value: "another_test_value")
    refute another_misc.save
  end

  test "should not allow miscellany items with matching names" do
    misc = Miscellany.new(key: "test_key", name: "test_name", description: "test_description", value: "test_value")
    assert misc.save

    another_misc = Miscellany.new(key: "another_test_key", name: "test_name", description: "another_test_description", value: "another_test_value")
    refute another_misc.save
  end

end
