require "test_helper"

class OneRepMaxTest < ActiveSupport::TestCase
  test "calculates one rep max correctly" do
    one_rep_max = OneRepMax.new(weight: 100, reps: 5)
    assert_in_delta 115, one_rep_max.calculate, 0.01
  end

  test "returns nil for invalid inputs" do
    assert_nil OneRepMax.new(weight: 0, reps: 5).calculate
    assert_nil OneRepMax.new(weight: 100, reps: 0).calculate
    assert_nil OneRepMax.new(weight: -10, reps: 5).calculate
  end

  test "rounds to nearest 2.5 increment" do
    # Testing various values get rounded correctly
    one_rep_max = OneRepMax.new(weight: 100, reps: 4)
    assert_equal 115.0, one_rep_max.calculate

    one_rep_max = OneRepMax.new(weight: 100, reps: 6)
    assert_equal 120.0, one_rep_max.calculate
  end

  test "assert not in range of nearest 5 pounds" do
    one_rep_max = OneRepMax.new(weight: 100, reps: 4)
    assert_not_in_delta 117.5, one_rep_max.calculate, 0.01

    one_rep_max = OneRepMax.new(weight: 100, reps: 6)
    assert_not_in_delta 122.5, one_rep_max.calculate, 0.01
  end
end
