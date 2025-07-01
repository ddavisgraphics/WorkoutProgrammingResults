require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  setup do
    @workout = workouts(:workout_a)
    @program = programs(:strength_program)
  end

  attr_reader :workout, :program

  # Association tests
  test 'belongs to a program' do
    assert_equal program, workout.program
  end

  test 'has many workout_exercises' do
    assert_respond_to workout, :workout_exercises
    assert_kind_of ActiveRecord::Associations::CollectionProxy, workout.workout_exercises
  end

  test 'has many exercises through workout_exercises' do
    assert_respond_to workout, :exercises
    assert_kind_of ActiveRecord::Associations::CollectionProxy, workout.exercises
  end

  test 'destroying a workout destroys associated workout_exercises' do
    exercise = exercises(:bench_press)
    workout_exercise = workout.workout_exercises.create!(
      exercise: exercise,
      position: 1,
      sets: 3,
      reps: 10
    )
    workout_exercise_id = workout_exercise.id

    assert_equal 4, workout.workout_exercises.count
    assert_difference 'WorkoutExercise.count', -4 do
      workout.destroy
    end

    assert_nil WorkoutExercise.find_by(id: workout_exercise_id)
  end

  # Enum tests
  test 'day_of_week enum works correctly' do
    # Test setting by string/symbol
    workout.day_of_week = :monday
    assert_equal 'monday', workout.day_of_week
    assert workout.monday?

    workout.day_of_week = 'wednesday'
    assert_equal 'wednesday', workout.day_of_week
    assert workout.wednesday?

    # Methods
    workout.friday!
    assert workout.friday?

    # Test integer values
    workout.day_of_week = 0
    assert_equal 'monday', workout.day_of_week

    workout.day_of_week = 3
    assert_equal 'thursday', workout.day_of_week

    workout.day_of_week = 6
    assert_equal 'sunday', workout.day_of_week
  end

  # Validation tests
  test 'requires a name' do
    workout.name = nil
    assert_not workout.valid?
    assert_includes workout.errors[:name], "can't be blank"
  end

  test 'requires a day_of_week' do
    workout.day_of_week = nil
    assert_not workout.valid?
    assert_includes workout.errors[:day_of_week], "can't be blank"
  end

  test 'requires valid day_of_week' do
    assert_raises(ArgumentError) do
      workout.day_of_week = 'someday'
    end

    # Valid days
    workout.day_of_week = 'monday'
    assert workout.valid?

    workout.day_of_week = 'wednesday'
    assert workout.valid?
  end

  test 'requires valid position' do
    # Nil position
    workout.position = nil
    assert_not workout.valid?
    assert_includes workout.errors[:position], "can't be blank"

    # Non-integer position
    workout.position = 1.5
    assert_not workout.valid?
    assert_includes workout.errors[:position], 'must be an integer'

    # Negative position
    workout.position = -1
    assert_not workout.valid?
    assert_includes workout.errors[:position], 'must be greater than or equal to 0'

    # Valid position
    workout.position = 0
    assert workout.valid?, 'Workout with position 0 should be valid'

    workout.position = 1
    assert workout.valid?, 'Workout with position 1 should be valid'
  end

  # Practical functionality tests
  test 'can add exercises to workout' do
    exercise = exercises(:bicep_curl)

    workout_exercise = workout.workout_exercises.build(
      exercise: exercise,
      position: 1,
      sets: 5,
      reps: 5,
      weight: 225.0
    )

    assert workout_exercise.valid?
    assert_difference 'workout.workout_exercises.count' do
      workout_exercise.save
    end

    assert_includes workout.exercises, exercise
  end

  test 'can retrieve workout details with exercises' do
    # Assuming fixtures have been set up with workout exercises
    exercise_count = workout.exercises.count
    assert exercise_count > 0, 'Expected workout to have exercises'

    first_exercise = workout.exercises.first
    assert_not_nil first_exercise, 'Expected to find at least one exercise'

    # Check we can access workout exercise details
    workout_exercise = workout.workout_exercises.where(exercise: first_exercise).first
    assert_not_nil workout_exercise, 'Expected to find workout exercise details'
    assert_respond_to workout_exercise, :sets
    assert_respond_to workout_exercise, :reps
    assert_respond_to workout_exercise, :weight
  end
end
