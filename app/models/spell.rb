class Spell < ApplicationRecord
  belongs_to :wizard
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :name, uniqueness: { scope: :wizard_id }
  after_create :notify_followers
  after_commit :produce_spell_created_event, on: :create

  private
  def notify_followers
    followers = wizard.followers
    followers.each do |follower|
      NotificationService.call(
        action: :spell_created,
        action_maker: wizard,
        receiver: follower,
        payload: { spell_name: name }
      )
    end
  end

  def produce_spell_created_event
    payload = {
      event_name: "spell.created",
      spell_id: self.id.to_s,
      spell_name: self.name,
      wizard_id: self.wizard.id.to_s,
      wizard_name: self.wizard.name,
      timestamp: self.created_at.iso8601
    }

    SpellsProducer.call(payload)
  end
end
