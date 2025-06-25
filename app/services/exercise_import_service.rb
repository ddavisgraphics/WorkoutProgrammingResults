# frozen_string_literal: true

require 'open-uri'
require 'fileutils'

# Import Data Service for Exercises
# This service fetches exercise data from a remote JSON file, imports or updates
# exercises in the database, and downloads associated images.
#
# Usage:
#   service = ExerciseImportService.new
#   stats = service.import_exercises
#   service.summary
#
# The service tracks statistics such as created, updated, unchanged exercises,
# and images downloaded or skipped.
class ExerciseImportService
  BASE_REPO_URL = 'https://github.com/ddavisgraphics/free-exercise-db.git'
  REPO_PATH = Rails.root.join('tmp', 'repos', 'free-exercise-db')
  EXERCISES_JSON_PATH = REPO_PATH.join('dist', 'exercises.json')
  IMAGES_PATH = REPO_PATH.join('exercises')
  GIT_REPO_DIRECTORY = Rails.root.join('tmp', 'repos')

  attr_reader :image_dir, :stats

  def initialize
    @image_dir = Rails.root.join('public', 'images', 'exercises')
    @stats = { created: 0, updated: 0, unchanged: 0, images_downloaded: 0, images_skipped: 0, errors: 0 }
  end

  def import_exercises
    git_sync_repository || raise('Failed to sync or clone the git repository.')
    import_or_update_exercises(fetch_exercises_data)
    stats
  end

  def summary
    <<~SUMMARY
      #{@stats[:created]} exercises created, #{@stats[:updated]} updated, #{@stats[:unchanged]} unchanged.
      Images: #{@stats[:images_downloaded]} downloaded, #{@stats[:images_skipped]} already existed,
      #{@stats[:errors]} errors.
    SUMMARY
  end

  private

  # @return [Array<Hash>] Parsed JSON data from the exercises.json file.
  def fetch_exercises_data
    JSON.parse(File.read(EXERCISES_JSON_PATH)) if File.exist?(EXERCISES_JSON_PATH)
  rescue StandardError => e
    raise "Error downloading exercises data: #{e.message}"
  end

  # Synchronizes the local git repository with the remote one.
  # If the repository does not exist, it clones it.
  # @return [Boolean] True if the repository was successfully synchronized or cloned.
  # @raise [StandardError] If there is an error during git operations.
  def git_sync_repository
    target_dir = Rails.root.join('tmp', 'repos', 'free-exercise-db')
    if git_repo?(target_dir)
      Dir.chdir(target_dir) do
        system('git pull --quiet')
        return true
      end
    else
      Dir.chdir(Rails.root.join('tmp')) do
        system("git clone --branch main #{BASE_REPO_URL} #{target_dir}")
        return true if git_repo?(target_dir)
      end
    end
  end

  # Directory Exists and contains a .git directory
  # @param dir [String]
  # @return [Boolean]
  def git_repo?(dir)
    Dir.exist?(dir) && Dir.exist?(File.join(dir, '.git'))
  end

  def import_or_update_exercises(exercises_data)
    exercises_data.each do |exercise_data|
      # Process exercise data
      image_urls = exercise_data.fetch('images', [])
      exercise = Exercise.find_or_initialize_by(name: exercise_data['name'])

      # Prepare attributes
      attributes = {
        force: exercise_data['force'],
        level: exercise_data['level'],
        mechanic: exercise_data['mechanic'],
        equipment: exercise_data['equipment'],
        primary_muscles: exercise_data['primaryMuscles'] || [],
        secondary_muscles: exercise_data['secondaryMuscles'] || [],
        instructions: exercise_data['instructions'] || [],
        category: exercise_data['category'],
        description: [exercise_data['category'], exercise_data['equipment']].compact.join(' - ')
      }

      exercise.assign_attributes(attributes)
      image_urls.each do |image|
        next if image.blank?

        IMAGES_PATH.join(image).tap do |image_path|
          if File.exist?(image_path)
            filename = File.basename(image_path)
            io = File.open(image_path, 'rb')
            content_type = content_type_for(filename)
            next if exercise.images.any? { |img| img.filename.to_s == filename }

            exercise.images.attach(io:, filename:, content_type:)
          else
            stats[:errors] += 1
            puts "Image file not found: #{image_path}"
          end
        end
      rescue StandardError => e
        stats[:errors] += 1
        puts "Error attaching image #{image}: #{e.message}"
      end

      exercise.save!
      print '.' if (@stats[:created] + @stats[:updated] + @stats[:unchanged]) % 10 == 0
    end
  end

  # MimeType
  # @return [String] The content type for the given filename.
  # @param filename [String] The name of the file to determine the content type for.
  # @example
  #   content_type_for('image.jpg') # => 'image/jpeg'
  #   content_type_for('document.pdf') # => 'application/pdf'
  def content_type_for(filename)
    case File.extname(filename).downcase
    when '.jpg', '.jpeg'
      'image/jpeg'
    when '.png'
      'image/png'
    when '.gif'
      'image/gif'
    when '.webp'
      'image/webp'
    else
      'application/octet-stream'
    end
  end
end
