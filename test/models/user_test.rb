require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @trainer = users(:trainer)
    @gym_rat = users(:gym_rat)
    @another_trainer = users(:another_trainer)
    @another_gym_rat = users(:another_gym_rat)
  end

  test 'admin? method returns true for admin users' do
    assert @admin.admin?
    assert_not @trainer.admin?
    assert_not @gym_rat.admin?
  end

  test 'trainer? method returns true for trainer users' do
    assert @trainer.trainer?
    assert @another_trainer.trainer?
    assert_not @admin.trainer?
    assert_not @gym_rat.trainer?
  end

  test 'gym_rat? method returns true for gym_rat users' do
    assert @gym_rat.gym_rat?
    assert @another_gym_rat.gym_rat?
    assert_not @admin.gym_rat?
    assert_not @trainer.gym_rat?
  end

  test 'should validate email uniqueness' do
    duplicate_user = User.new(email: @admin.email, password: 'password', role: 'trainer')
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], 'has already been taken'
  end

  test 'should validate presence of role' do
    user = User.new(email: 'test@example.com', password: 'password')
    user.role = nil
    assert_not user.valid?
    assert_includes user.errors[:role], "can't be blank"
  end

  test 'should validate inclusion of role in allowed roles' do
    user = User.new(email: 'test@example.com', password: 'password', role: 'invalid_role')
    assert_not user.valid?
    assert_includes user.errors[:role], 'is not included in the list'
  end

  test 'display_name returns username part of the email' do
    user = User.new(email: 'john.doe@example.com')
    assert_equal 'John Doe', user.display_name
  end

  test 'role_name returns titleized version of role' do
    assert_equal 'Admin', @admin.role_name
    assert_equal 'Trainer', @trainer.role_name
    assert_equal 'Gym Rat', @gym_rat.role_name
  end

  test 'except class method excludes the given user' do
    users = User.except(@admin)
    assert_not users.include?(@admin)
    assert users.include?(@trainer)
  end

  test 'role_counts returns count of users by role' do
    counts = User.role_counts
    assert_equal User.where(role: 'admin').count, counts['admin']
    assert_equal User.where(role: 'trainer').count, counts['trainer']
    assert_equal User.where(role: 'gym_rat').count, counts['gym_rat']
  end
end
