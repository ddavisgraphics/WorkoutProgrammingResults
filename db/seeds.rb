# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts '====== Creating Demo Users ======'

# Constants for the seeding process
DEFAULT_PASSWORD = 'password123'
ADMIN_COUNT = 2
TRAINER_COUNT = 5
GYM_RAT_COUNT = 10

# Function to create a user with given attributes
def create_user(email, role)
  user = User.find_or_initialize_by(email: email)
  user.assign_attributes(
    password: DEFAULT_PASSWORD,
    password_confirmation: DEFAULT_PASSWORD,
    role: role
  )

  if user.save
    puts "#{role.capitalize} user created: #{email} / #{DEFAULT_PASSWORD}"
  else
    puts "Failed to create user #{email}: #{user.errors.full_messages.join(', ')}"
  end

  user
end

# Create main demo users (these are fixed accounts for easy login)
puts "\n--- Creating Main Demo Users ---"
create_user('admin@example.com', 'admin')
create_user('trainer@example.com', 'trainer')
create_user('user@example.com', 'gym_rat')

# Create additional admin users
puts "\n--- Creating Additional Admin Users ---"
ADMIN_COUNT.times do |i|
  create_user("admin#{i + 1}@example.com", 'admin')
end

# Create additional trainer users
puts "\n--- Creating Additional Trainer Users ---"
TRAINER_COUNT.times do |i|
  create_user("trainer#{i + 1}@example.com", 'trainer')
end

# Create additional gym rat users
puts "\n--- Creating Additional Gym Rat Users ---"
GYM_RAT_COUNT.times do |i|
  create_user("user#{i + 1}@example.com", 'gym_rat')
end

# Summary of created users
puts "\n====== User Creation Summary ======"
puts "Total users created: #{User.count}"
puts "Admin users: #{User.where(role: 'admin').count}"
puts "Trainer users: #{User.where(role: 'trainer').count}"
puts "Gym Rat users: #{User.where(role: 'gym_rat').count}"
puts '====== Seed data creation complete! ======'
