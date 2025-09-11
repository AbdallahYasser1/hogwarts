require "test_helper"

class WizardPolicyTest < ActiveSupport::TestCase
  def test_update
    wizard = wizards(:hermione)
    admin = wizards(:mcgonagall)
    other = wizards(:harry)
    assert WizardPolicy.new(wizard, wizard).update?
    assert WizardPolicy.new(admin, other).update?
    assert_not WizardPolicy.new(other, admin).update?
  end
end
