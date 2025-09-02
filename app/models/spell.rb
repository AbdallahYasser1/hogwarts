class Spell < ApplicationRecord
  belongs_to :wizard
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :name, uniqueness: { scope: :wizard_id }
end
