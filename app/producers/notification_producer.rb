class NotificationProducer
  CHANNELS = %w[email sms push_notification].freeze

  def self.send_notification(action_maker, message, receiver_id)
    channel = CHANNELS.sample

    payload = {
      action_maker: action_maker.name,
      message: message,
      receiver_id: receiver_id,
      timestamp: Time.now.utc
    }.to_json

    Karafka.producer.produce_async(
      topic: "notification_producer_#{channel}",
      payload: payload
    )
  end
end
