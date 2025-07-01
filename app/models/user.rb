# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # initialize the role to gym_rate for normal users
  after_initialize :set_default_role, if: :new_record?

  ROLES = %w[admin trainer gym_rat].freeze
  validates :role, presence: true, inclusion: { in: ROLES }

  # @return [Boolean]
  def admin?
    role == 'admin'
  end

  # @return [Boolean]
  def trainer?
    role == 'trainer'
  end

  # @return [Boolean]
  def gym_rat?
    role == 'gym_rat'
  end

  # @return [String]
  def set_default_role
    self.role ||= 'gym_rat'
  end

  # Returns a display name for the user
  # @return [String]
  def display_name
    email.split('@').first.titleize
  end

  # Returns a formatted version of the role
  # @return [String]
  def role_name
    role.titleize
  end

  # Returns all users except the current one
  # @return [ActiveRecord::Relation]
  def self.except(user)
    where.not(id: user)
  end

  # Returns a count of users by role
  # @return [Hash]
  def self.role_counts
    group(:role).count
  end
end
