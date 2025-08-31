require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @wizard = wizards(:harry)
  end

  test "should get login page" do
    get login_path
    assert_response :success
    assert_select "form"
  end

  test "should login with valid credentials" do
    post login_path, params: { email: @wizard.email, password: "Potter007" }
    assert_redirected_to landing_path
    follow_redirect!
    assert_select "a", text: "Welcome, #{ @wizard.name }"
  end

  test "should not login with invalid credentials" do
    post login_path, params: { email: @wizard.email, password: "wrongpassword" }
    assert_response :success
    assert_select ".alert", text: /Invalid email or password/
  end

  test "should logout" do
    post login_path, params: { email: @wizard.email, password: "Potter007" }
    delete logout_path
    assert_redirected_to login_path
    follow_redirect!
    assert_select "span", text: "Login"
  end

  test "should remember wizard when remember_me is checked" do
    post login_path, params: { email: @wizard.email, password: "Potter007", remember_me: "1" }
    assert_not_nil cookies[:remember_token]
  end

  test "should not remember wizard when remember_me is not checked" do
    post login_path, params: { email: @wizard.email, password: "Potter007", remember_me: "0" }
    assert_nil cookies[:remember_token]
  end
end
