require "test_helper"

class SpellsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wizard = wizards(:hermione)
    @admin = wizards(:mcgonagall)
    @other = wizards(:harry)
    @spell = spells(:expelliarmus)
    sign_in @wizard
  end

  test "should get index for own spells" do
    get wizard_spells_path(@wizard)
    assert_response :success
  end

  test "should get index for another wizard" do
    get wizard_spells_path(@other)
    assert_response :success
  end

  test "should show spell" do
    get wizard_spell_path(@wizard, @spell)
    assert_response :success
    assert_select "h2", /Expelliarmus/
  end

  test "should create spell as owner" do
    assert_difference "Spell.count" do
      post wizard_spells_path(@wizard), params: { spell: { name: "item-test", description: "Light spell." } }
    end
    assert_redirected_to wizard_spell_path(@wizard, Spell.last)
  end

  test "should not create spell as other wizard" do
    sign_out @wizard
    sign_in @other
    assert_raise Pundit::NotAuthorizedError do
      post wizard_spells_path(@wizard), params: { spell: { name: "Lumos", description: "Light spell." } }
    end
  end

  test "should update spell as owner" do
    patch wizard_spell_path(@wizard, @spell), params: { spell: { description: "Updated desc." } }
    assert_redirected_to wizard_spell_path(@wizard, @spell)
    @spell.reload
    assert_equal "Updated desc.", @spell.description
  end
  test "should update other spell as admin" do
    sign_in @admin
    patch wizard_spell_path(@wizard, @spell), params: { spell: { description: "Updated desc." } }
    assert_redirected_to wizard_spell_path(@wizard, @spell)
    @spell.reload
    assert_equal "Updated desc.", @spell.description
  end

  test "should not update spell as other wizard" do
    sign_out @wizard
    sign_in @other
    assert_raise Pundit::NotAuthorizedError do
      patch wizard_spell_path(@wizard, @spell), params: { spell: { description: "Malicious" } }
    end
  end

  test "should destroy other spell as owner" do
    assert_difference "Spell.count", -1 do
      delete wizard_spell_path(@wizard, @spell)
    end
    assert_redirected_to wizard_spells_path(@wizard)
  end
  test "should destroy spell as admin" do
     sign_in @admin
    assert_difference "Spell.count", -1 do
      delete wizard_spell_path(@wizard, @spell)
    end
    assert_redirected_to wizard_spells_path(@wizard)
  end
  test "should not destroy spell as other wizard" do
    sign_out @wizard
    sign_in @other
    assert_raise Pundit::NotAuthorizedError do
      delete wizard_spell_path(@wizard, @spell)
    end
  end
end
