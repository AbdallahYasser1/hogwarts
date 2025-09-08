class WizardFollow < ApplicationRecord
  belongs_to :follower, class_name: "Wizard"
  belongs_to :followed, class_name: "Wizard"

  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :cannot_follow_self
  after_commit :produce_follow_created_event, on: :create

  private
  def cannot_follow_self
    errors.add(:follower_id, "can't follow yourself") if follower_id == followed_id
  end

  def produce_follow_created_event
    payload = {
      event_name: "follow.created",
      follower_id: self.follower_id.to_s,
      follower_name: self.follower.name,
      followed_id: self.followed_id.to_s,
      followed_name: self.followed.name,
      timestamp: self.created_at.iso8601
    }

    FollowsProducer.call(payload)
  end
end
