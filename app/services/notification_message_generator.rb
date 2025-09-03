module NotificationMessageGenerator
  def self.for(action:, action_maker:, payload: {})
    case action
    when :follow
      "#{action_maker.name} started following you."
    when :spell_created
      # Assumes the payload hash contains a :spell_name key
      spell_name = payload[:spell_name] || "a new spell"
      "#{action_maker.name} just created a new spell: '#{spell_name}'!"
    else
      # A fallback for any unknown notification types
      "You have a new notification from #{action_maker.name}."
    end
  end
end
