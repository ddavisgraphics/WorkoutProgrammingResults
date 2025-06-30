require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  attr_reader :exercise

  setup do
    @exercise = exercises(:bench_press)
  end

  # Validation Tests
  test 'requires a name' do
    exercise.name = nil
    assert_not exercise.valid?
    assert_includes exercise.errors[:name], "can't be blank"
  end

  test 'name must be unique' do
    duplicate_exercise = Exercise.new(name: exercise.name)
    assert_not duplicate_exercise.valid?
    assert_includes duplicate_exercise.errors[:name], 'has already been taken'
  end

  # Association Tests
  test 'has many attached images' do
    assert_respond_to exercise, :images
    assert_kind_of ActiveStorage::Attached::Many, exercise.images
  end

  # Method Tests
  test 'primary_image_url returns url of first image' do
    # Mock the first image with a url
    mock_attachment = mock
    mock_attachment.expects(:url).returns('http://example.com/image.jpg')

    exercise.images.expects(:first).returns(mock_attachment)

    assert_equal 'http://example.com/image.jpg', exercise.primary_image_url
  end

  test 'primary_image_url returns nil when no images' do
    exercise.images.expects(:first).returns(nil)
    assert_nil exercise.primary_image_url
  end

  # Attribute Tests
  test 'has all required attributes' do
    assert_respond_to exercise, :name
    assert_respond_to exercise, :force
    assert_respond_to exercise, :level
    assert_respond_to exercise, :mechanic
    assert_respond_to exercise, :equipment
    assert_respond_to exercise, :primary_muscles
    assert_respond_to exercise, :secondary_muscles
    assert_respond_to exercise, :instructions
    assert_respond_to exercise, :category
    assert_respond_to exercise, :image_urls
    assert_respond_to exercise, :description
  end

  test 'stores arrays in jsonb columns' do
    # Test primary_muscles is an array
    exercise.primary_muscles = %w[chest triceps]
    exercise.save
    exercise.reload
    assert_equal %w[chest triceps], exercise.primary_muscles

    # Test secondary_muscles is an array
    exercise.secondary_muscles = ['shoulders']
    exercise.save
    exercise.reload
    assert_equal ['shoulders'], exercise.secondary_muscles

    # Test instructions is an array
    exercise.instructions = ['Step 1', 'Step 2']
    exercise.save
    exercise.reload
    assert_equal ['Step 1', 'Step 2'], exercise.instructions

    # Test image_urls is an array
    exercise.image_urls = ['http://example.com/1.jpg', 'http://example.com/2.jpg']
    exercise.save
    exercise.reload
    assert_equal ['http://example.com/1.jpg', 'http://example.com/2.jpg'], exercise.image_urls
  end
end
