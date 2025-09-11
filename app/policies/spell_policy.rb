class SpellPolicy < ApplicationPolicy
  attr_reader :wizard, :spell

  def initialize(wizard, spell)
    @wizard = wizard
    @spell = spell
  end

  def create?
    wizard.is_admin? || wizard == spell.wizard
  end

  def update?
    wizard.is_admin? || wizard == spell.wizard
  end

  def destroy?
    wizard.is_admin? || wizard == spell.wizard
  end
end
