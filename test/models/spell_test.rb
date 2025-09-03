require "test_helper"

class SpellTest < ActiveSupport::TestCase
  def setup
    @wizard = wizards(:hermione)
    @spell = @wizard.spells.build(name: "Item-test", description: "Disarming spell.")
  end

  test "should be valid" do
    assert @spell.valid?
  end

  test "name should be present" do
    @spell.name = ""
    assert_not @spell.valid?
  end

  test "description should be present" do
    @spell.description = ""
    assert_not @spell.valid?
  end

  test "name should be unique per wizard" do
    @spell.save
    duplicate = @wizard.spells.build(name: "Expelliarmus", description: "Another desc.")
    assert_not duplicate.valid?
  end

  test "description should not exceed 500 chars" do
    @spell.description = "a" * 501
    assert_not @spell.valid?
  end
end
