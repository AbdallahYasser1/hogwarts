class Spell < ApplicationRecord
  belongs_to :wizard
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :name, uniqueness: { scope: :wizard_id }
  after_create :notify_followers
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
end
