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
end
