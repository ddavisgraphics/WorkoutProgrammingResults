# frozen_string_literal: true

class OneRepMax
  attr_reader :weight, :reps

  def initialize(weight:, reps:)
    @weight = weight.to_i
    @reps = reps.to_i
  end

  # Epley formula for one-rep max calculation
  # @return [Integer] one-rep max
  def calculate
    return if @weight <= 0 || @reps <= 0

    max = average_of_all_formulas
    weight_to_nearest_5_pound(max)
  end

  # @return [Hash] results of all formulas
  def results_of_all_formulas
    results_of_all_formulas ||= {}
    %w[brzycki_formula epley_formula lombardi_formula lander_formula mayhew_formula].each do |formula|
      results_of_all_formulas[formula] = send(formula)
    end
    results_of_all_formulas
  end

  # @return [Float] average of all formulas
  def average_of_all_formulas
    @average_of_all_formulas ||= results_of_all_formulas.values.sum / results_of_all_formulas.size
  end

  private

  # Brzycki formula for estimating one-rep max
  # Most accurate for 1-10 reps range
  # @return [Float] estimated one-rep max
  def brzycki_formula
    weight / (1.0278 - 0.0278 * reps)
  end

  # Epley formula for estimating one-rep max
  # Commonly used for moderate to high rep ranges
  # @return [Float] estimated one-rep max
  def epley_formula
    weight * (1 + (reps / 30.0))
  end

  # Mayhew formula for estimating one-rep max
  # More complex formula that uses exponential function
  # @return [Float] estimated one-rep m
  def mayhew_formula
    weight * (100 / (52.2 + 41.9 * Math.exp(-0.055 * reps)))
  end

  # Lombardi formula for estimating one-rep max
  # Simple power formula that tends to be more conservative
  # @return [Float] estimated one-rep max
  def lombardi_formula
    weight * (reps**0.10)
  end

  # Lander formula for estimating one-rep max
  # Linear model that some find more accurate for higher rep ranges
  # @return [Float] estimated one-rep max
  def lander_formula
    (weight * 100) / (101.3 - 2.67123 * reps)
  end

  # One rep max should be rounded to the nearest 5 pounds
  # to establish what a user could theoretically put on the bar and assuming it is the standard us weights
  def weight_to_nearest_5_pound(value)
    (value / 5).round * 5
  end
end
