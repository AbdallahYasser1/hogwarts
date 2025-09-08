# app/consumers/notifications_consumer.rb
class NotificationsConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      payload = message.payload

      Rails.logger.info "
      ~~~~~~~~~~~~~~ KAFKA NOTIFICATION RECEIVED ~~~~~~~~~~~~~~
      Topic: #{message.topic}
      Action Maker: #{payload['action_maker']}
      Message: '#{payload['message']}'
      Receiver ID: #{payload['receiver_id']}
      Timestamp: #{payload['timestamp']}
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      "
    end
  end
end
