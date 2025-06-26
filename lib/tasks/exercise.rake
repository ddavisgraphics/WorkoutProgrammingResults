# frozen_string_literal: true

namespace :exercise do
  desc 'Import exercises through ActiveJob (benchmark included)'
  task import_job: :environment do
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    service = ExerciseImportService.new
    service.import_exercises
    puts service.summary

    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Import task completed in #{elapsed.round(2)} seconds."
  end
end
