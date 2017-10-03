require 'test_helper'

class AdminsControllerTest < ActionController::TestCase

  test "should redirect to login if we wang to get index without login" do
    get :index
    assert_redirected_to login_url
  end

  test "should show the admin information" do
    get :show
    assert_redirected_to  action:"set_admin"
  end


end

