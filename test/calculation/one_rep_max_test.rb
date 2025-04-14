require 'test_helper'

class OneRepMaxTest < ActiveSupport::TestCase
  test 'calculates one rep max correctly' do
    one_rep_max = OneRepMax.new(weight: 100, reps: 5)
    assert_in_delta 115, one_rep_max.calculate, 0.01
  end

  test 'returns nil for invalid inputs' do
    assert_nil OneRepMax.new(weight: 0, reps: 5).calculate
    assert_nil OneRepMax.new(weight: 100, reps: 0).calculate
    assert_nil OneRepMax.new(weight: -10, reps: 5).calculate
  end

  test 'rounds to nearest 2.5 increment' do
    # Testing various values get rounded correctly
    one_rep_max = OneRepMax.new(weight: 100, reps: 4)
    assert_equal 115.0, one_rep_max.calculate

    one_rep_max = OneRepMax.new(weight: 100, reps: 6)
    assert_equal 120.0, one_rep_max.calculate
  end

  test 'assert not in range of nearest 5 pounds' do
    one_rep_max = OneRepMax.new(weight: 100, reps: 4)
    assert_not_in_delta 117.5, one_rep_max.calculate, 0.01

    one_rep_max = OneRepMax.new(weight: 100, reps: 6)
    assert_not_in_delta 122.5, one_rep_max.calculate, 0.01
  end

  test 'calculates all formulas correctly' do
    one_rep_max = OneRepMax.new(weight: 100, reps: 5)
    results = one_rep_max.results_of_all_formulas

    assert_in_delta 116.6, results['epley_formula'], 0.5
    assert_in_delta 112.5, results['brzycki_formula'], 0.5
    assert_in_delta 119.0, results['mayhew_formula'], 0.5
    assert_in_delta 117.4, results['lombardi_formula'], 0.5
    assert_in_delta 113.7, results['lander_formula'], 0.5
  end

  test 'calculates average of all formulas correctly' do
    one_rep_max = OneRepMax.new(weight: 100, reps: 5)
    average = one_rep_max.average_of_all_formulas

    assert_in_delta 115.4, average, 0.5
  end
end
