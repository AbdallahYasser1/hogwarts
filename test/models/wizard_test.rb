require "test_helper"

class WizardTest < ActiveSupport::TestCase
  def setup
  @wizard = wizards(:hermione)
  end

  test "should be valid" do
  assert @wizard.valid?, @wizard.errors.full_messages.join(", ")
  end

  test "name should be present" do
    @wizard.name = nil
    assert_not @wizard.valid?
  end

  test "email should be unique" do
    duplicate = Wizard.new(@wizard.attributes.except("id"))
    duplicate.email = wizards(:harry).email
    assert_not duplicate.valid?
  end

  test "password format should be valid" do
    @wizard.password = "badpass"
  assert_not @wizard.valid?
  end

  test "hogwarts_house is automatically assigned on create" do
    attrs = wizards(:hermione).attributes.symbolize_keys.except(:id, :hogwarts_house, :encrypted_password)
    attrs[:email] = "newwizard@hogwarts.com"
    attrs[:password] = "BookWorm1"
    wizard = Wizard.create(attrs)
    assert wizard.hogwarts_house.present?
  end
end
