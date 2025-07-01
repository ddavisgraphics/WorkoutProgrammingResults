# frozen_string_literal: true

class ImpersonationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, except: [:stop]

  # Start impersonating a user
  def create
    user = User.find(params[:user_id])
    impersonate_user(user)
    redirect_to root_path, notice: "Now impersonating #{user.email}"
  end

  # Stop impersonating and return to admin account
  def stop
    return redirect_to root_path, alert: 'You are not impersonating anyone' unless current_user_impersonated?

    stop_impersonating_user
    redirect_to root_path, notice: 'Stopped impersonating user'
  end

  private

  def authorize_admin!
    return if current_user.admin?

    redirect_to root_path, alert: 'You are not authorized to perform this action'
  end
end
