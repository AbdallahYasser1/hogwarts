require "test_helper"

class RegistrationServiceTest < ActiveSupport::TestCase
  test "register creates wizard with valid params" do
    params = {
      name: "Hermione Granger",
      email: "hermione@hogwarts.com",
      password: "BookWorm1",
      date_of_birth: "1979-09-19",
      bio: "Brightest witch of her age.",
      muggle_relatives: true
    }
    wizard = RegistrationService.new(params).register
    assert wizard.persisted?
    assert_equal "Hermione Granger", wizard.name
  end

  test "register fails with invalid password format" do
    params = {
      name: "Ron Weasley",
      email: "ron@hogwarts.com",
      password: "weasley",
      date_of_birth: "1980-03-01",
      bio: "Loyal friend.",
      muggle_relatives: false
    }
    wizard = RegistrationService.new(params).register
    refute wizard.persisted?
    assert_includes wizard.errors[:password], "must include at least one uppercase letter, one lowercase letter, and one number"
  end

  test "register fails with duplicate email" do
    Wizard.create!(name: "Harry Potter", email: "harry@hogwarts.com", password: "Potter007", date_of_birth: "1980-07-31", bio: "The Boy Who Lived.", muggle_relatives: true)
    params = {
      name: "Harry Potter",
      email: "harry@hogwarts.com",
      password: "Potter007",
      date_of_birth: "1980-07-31",
      bio: "Duplicate email test.",
      muggle_relatives: true
    }
    wizard = RegistrationService.new(params).register
    refute wizard.persisted?
    assert_includes wizard.errors[:email], "has already been taken"
  end

  test "register fails with bio too long" do
    params = {
      name: "Luna Lovegood",
      email: "luna@hogwarts.com",
      password: "Ravenclaw1",
      date_of_birth: "1981-02-13",
      bio: "a" * 301,
      muggle_relatives: false
    }
    wizard = RegistrationService.new(params).register
    refute wizard.persisted?
    assert_includes wizard.errors[:bio], "must be 300 characters or less"
  end

  test "register fails with missing required fields" do
    params = {
      email: "neville@hogwarts.com",
      password: "Herbology1"
    }
    wizard = RegistrationService.new(params).register
    refute wizard.persisted?
    assert_includes wizard.errors[:name], "can't be blank"
    assert_includes wizard.errors[:date_of_birth], "can't be blank"
  end

  test "register allows admin without password format validation" do
    params = {
      name: "Minerva McGonagall",
      email: "mcgonagall@hogwarts.com",
      password: "transfiguration",
      date_of_birth: "1950-10-04",
      bio: "Head of Gryffindor House.",
      muggle_relatives: false,
      is_admin: true
    }
    wizard = RegistrationService.new(params).register
    assert wizard.persisted?
    assert wizard.is_admin
  end
end
