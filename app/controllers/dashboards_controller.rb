# frozen_string_literal: true

# app/controllers/dashboards_controller.rb
class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    case current_user.role
    when 'admin'
      render 'dashboards/admin'
    when 'trainer'
      render 'dashboards/trainer'
    else
      render 'dashboards/gym_rat'
    end
  end
end
