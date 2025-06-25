# frozen_string_literal: true

namespace :exercise do
  desc "Import exercises through ActiveJob (benchmark included)"
  task import_job: :environment do
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    service = ExerciseImportService.new
    stats = service.import_exercises
    puts service.summary


    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Import task completed in #{elapsed.round(2)} seconds."
  end

  desc "Import exercises from cloned free-exercise-db repo"
  task import_from_clone: :environment do
    require 'fileutils'

    # Clone repo to tmp directory
    tmp_dir = Rails.root.join('tmp', 'free-exercise-db')
    FileUtils.rm_rf(tmp_dir) if Dir.exist?(tmp_dir)

    puts "Cloning free-exercise-db repository..."
    system("git clone https://github.com/ddavisgraphics/free-exercise-db.git #{tmp_dir}")

    # Copy exercises JSON and images to your app
    FileUtils.cp(File.join(tmp_dir, 'dist', 'exercises.json'), Rails.root.join('db', 'data', 'exercises.json'))

    # Copy images
    images_dir = Rails.root.join('public', 'images', 'exercises')
    FileUtils.mkdir_p(images_dir)
    FileUtils.cp_r(Dir.glob(File.join(tmp_dir, 'exercises', '*')), images_dir)

    puts "Files imported successfully"

    # Clean up
    FileUtils.rm_rf(tmp_dir)
  end
end