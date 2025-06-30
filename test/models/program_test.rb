require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  setup do
    @user = users(:gym_rat)
    @program = programs(:strength_program)
  end

  attr_reader :program, :user

  # Association tests
  test 'belongs to a user' do
    assert_equal user, program.user
  end

  test 'user can be optional' do
    program.user = nil
    assert program.valid?
  end

  test 'has many workouts' do
    assert_respond_to program, :workouts
    assert_kind_of ActiveRecord::Associations::CollectionProxy, program.workouts
  end

  test 'workouts are ordered by day_of_week and position' do
    map = program.workouts.map do |w|
      [w.day_of_week, w.position]
    end
    assert_equal([['tuesday', 1], ['thursday', 2], ['saturday', 3]], map)
  end

  test 'destroying a program destroys associated workouts' do
    program = programs(:beginner_program)

    workout = program.workouts.create!(day_of_week: 1, position: 1, name: 'Test Workout')
    workout_id = workout.id

    assert_difference 'Workout.count', -1 do
      program.destroy
    end

    assert_nil Workout.find_by(id: workout_id)
  end

  # Enum tests
  test 'level enum works correctly' do
    # Test setting by string/symbol
    program.level = :beginner
    assert_equal 'beginner', program.level
    assert program.level_beginner?

    program.level = 'intermediate'
    assert_equal 'intermediate', program.level
    assert program.level_intermediate?

    program.level = 'advanced'
    assert_equal 'advanced', program.level
    assert program.level_advanced?

    # methods
    program.level_intermediate!
    assert program.level_intermediate?

    # Test integer values
    program.level = 0
    assert_equal 'beginner', program.level

    program.level = 1
    assert_equal 'intermediate', program.level

    program.level = 2
    assert_equal 'advanced', program.level
  end

  test 'visibility enum works correctly' do
    program.visibility_public!
    assert_equal 'public', program.visibility
    assert program.visibility_public?

    program.visibility = :private
    assert_equal 'private', program.visibility
    assert program.visibility_private?

    program.visibility = 'premium'
    assert_equal 'premium', program.visibility
    assert program.visibility_premium?
  end

  # Validation tests
  test 'requires a name' do
    program.name = nil
    assert_not program.valid?
    assert_includes program.errors[:name], "can't be blank"
  end

  test 'requires weeks to be present and positive' do
    program.weeks = nil
    assert_not program.valid?
    assert_includes program.errors[:weeks], "can't be blank"

    # Zero weeks
    program.weeks = 0
    assert_not program.valid?
    assert_includes program.errors[:weeks], 'must be greater than 0'

    # Negative weeks
    program.weeks = -1
    assert_not program.valid?
    assert_includes program.errors[:weeks], 'must be greater than 0'

    # Valid weeks
    program.weeks = 1
    assert program.valid?, 'Program with 1 week should be valid'
  end

  test 'requires active to be boolean' do
    # Test nil value
    program.active = nil
    assert_not program.valid?
    assert_includes program.errors[:active], 'is not included in the list'

    # Test valid values
    program.active = true
    assert program.valid?

    program.active = false
    assert program.valid?
  end

  test 'requires valid level' do
    assert_raises(ArgumentError) do
      program.level = 'expert'
    end

    # Valid levels
    program.level = 'beginner'
    assert program.valid?

    program.level = 'intermediate'
    assert program.valid?

    program.level = 'advanced'
    assert program.valid?
  end

  test 'requires valid visibility' do
    # Invalid visibility
    program = Program.new(@program_attributes)
    assert_raises(ArgumentError) do
      program.visibility = 'friends_only'
    end
  end

  # Scopes and utility method tests
  test 'finds public programs' do
    program_attributes = programs(:strength_program).attributes.reject { |key, _| key == 'id' }

    # Create programs with different visibility
    private_program = Program.create!(program_attributes.merge(name: 'Private', visibility: 'private'))
    public_program = Program.create!(program_attributes.merge(name: 'Public', visibility: 'public'))
    premium_program = Program.create!(program_attributes.merge(name: 'Premium', visibility: 'premium'))

    public_programs = Program.where(visibility: Program.visibilities[:public])
    assert_includes public_programs, public_program
    assert_not_includes public_programs, private_program
    assert_not_includes public_programs, premium_program
  end

  test 'finds premium programs' do
    program_attributes = programs(:strength_program).attributes.reject { |key, _| key == 'id' }

    # Create programs with different visibility
    private_program = Program.create!(program_attributes.merge(name: 'Private', visibility: 'private'))
    public_program = Program.create!(program_attributes.merge(name: 'Public', visibility: 'public'))
    premium_program = Program.create!(program_attributes.merge(name: 'Premium', visibility: 'premium'))

    premium_programs = Program.where(visibility: Program.visibilities[:premium])
    assert_includes premium_programs, premium_program
    assert_not_includes premium_programs, private_program
    assert_not_includes premium_programs, public_program
  end
end
