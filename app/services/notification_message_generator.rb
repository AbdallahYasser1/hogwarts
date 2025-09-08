module NotificationMessageGenerator
  def self.for(action:, action_maker:, payload: {})
    case action
    when :follow
      "#{action_maker.name} started following you."
    when :spell_created
      spell_name = payload[:spell_name] || "a new spell"
      "#{action_maker.name} just created a new spell: '#{spell_name}'!"
    else
      "You have a new notification from #{action_maker.name}."
    end
  end
end
