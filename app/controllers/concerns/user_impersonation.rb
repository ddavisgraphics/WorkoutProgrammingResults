# frozen_string_literal: true

module UserImpersonation
  extend ActiveSupport::Concern

  included do
    # Helper method for views to check if currently impersonating
    helper_method :current_user_impersonated? if respond_to?(:helper_method)
  end

  # Override the current_user method from Devise to allow impersonation
  def current_user
    # Check if we're impersonating someone
    if session[:impersonated_user_id].present?
      # Get the impersonated user
      @current_user ||= User.find_by(id: session[:impersonated_user_id])

      # If user not found, clear the session and fallback to normal behavior
      if @current_user.nil?
        session.delete(:impersonated_user_id)
        session.delete(:true_user_id)
        super
      else
        @current_user
      end
    else
      # Normal devise behavior
      super
    end
  end

  # Returns true if we're currently impersonating someone
  def current_user_impersonated?
    session[:impersonated_user_id].present?
  end

  # Returns the real user who is doing the impersonation
  def true_user
    if current_user_impersonated?
      @true_user ||= User.find_by(id: session[:true_user_id])
    else
      current_user
    end
  end

  # Start impersonating a user
  def impersonate_user(user)
    # Store the original user id
    session[:true_user_id] = current_user.id
    # Set the impersonated user id
    session[:impersonated_user_id] = user.id
  end

  # Stop impersonating and return to original user
  def stop_impersonating_user
    # Get back the original user
    @current_user = User.find_by(id: session[:true_user_id])

    # Clear the impersonation session data
    session.delete(:impersonated_user_id)
    session.delete(:true_user_id)
  end
end
