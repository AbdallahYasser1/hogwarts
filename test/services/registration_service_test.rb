
require "test_helper"

class RegistrationServiceTest < ActiveSupport::TestCase
  test "register creates wizard" do
    params = {
      name: "Test Wizard",
      email: "wizard@example.com",
      password: "Test123",
      date_of_birth: "2000-01-01"
    }
    wizard = RegistrationService.new(params).register
    assert wizard.persisted?
    assert_equal "Test Wizard", wizard.name
  end

  test "register fails with invalid params" do
    params = { email: "bad@example.com", password: "bad" }
    wizard = RegistrationService.new(params).register
    refute wizard.persisted?
  end
end
