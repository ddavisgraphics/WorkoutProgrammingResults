require 'test_helper'

class ImpersonationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin)
    @regular_user = users(:gym_rat)
  end

  test 'admin can impersonate another user' do
    sign_in @admin

    post impersonate_path(@regular_user)

    follow_redirect!
    assert_equal @regular_user.id, session[:impersonated_user_id]
    assert_equal @admin.id, session[:true_user_id]
    assert_response :success
  end

  test 'admin can stop impersonating' do
    sign_in @admin

    # Start impersonation
    post impersonate_path(@regular_user)

    # Stop impersonation
    delete stop_impersonating_path

    follow_redirect!
    assert_nil session[:impersonated_user_id]
    assert_nil session[:true_user_id]
    assert_response :success
  end

  test 'non-admin cannot impersonate others' do
    sign_in @regular_user

    post impersonate_path(@admin)

    assert_redirected_to root_path
    assert_nil session[:impersonated_user_id]
    assert_equal 'You are not authorized to perform this action', flash[:alert]
  end

  test 'impersonated user can still stop impersonation' do
    sign_in @admin

    # Start impersonation
    post impersonate_path(@regular_user)

    # Now acting as the regular user, try to stop impersonation
    delete stop_impersonating_path

    follow_redirect!
    assert_nil session[:impersonated_user_id]
    assert_nil session[:true_user_id]
    assert_response :success
  end
end
