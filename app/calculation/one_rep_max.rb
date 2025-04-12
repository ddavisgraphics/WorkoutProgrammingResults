class OneRepMax
  def initialize(weight:, reps:)
    @weight = weight
    @reps = reps
  end

  # Epley formula for one-rep max calculation
  # @return [Integer] one-rep max
  def calculate
    return if @weight <= 0 || @reps <= 0
    max = @weight * (1 + (@reps / 30.0))
    weight_to_nearest_5_pound(max)
  end

  private

  # One rep max should be rounded to the nearest 5 pounds
  # to establish what a user could theoretically put on the bar and assuming it is the standard us weights
  def weight_to_nearest_5_pound(value)
    (value / 5).round * 5
  end
end
