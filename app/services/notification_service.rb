class NotificationService
  def self.call(action:, action_maker:, receiver:, payload: {})
    message = NotificationMessageGenerator.for(
      action: action,
      action_maker: action_maker,
      payload: payload
    )

    NotificationProducer.send_notification(
      action_maker,
      message,
      receiver.id
    )
  end
end
