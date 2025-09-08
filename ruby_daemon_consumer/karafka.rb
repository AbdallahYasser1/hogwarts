# ruby_daemon_consumer/karafka.rb

class NotificationsConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
        payload = message.payload

    # Use puts for logging in a non-Rails app.
    # The new emoji 🚀 will confirm this new consumer is working.
    puts "\n~~~~~~~~~~~~~~ 🚀 STANDALONE KARAFKA RECEIVED ~~~~~~~~~~~~~~"
    puts "Topic: #{message.topic}"
    puts "Action Maker: #{payload['action_maker']}"
    puts "Message: '#{payload['message']}'"
    puts "Receiver ID: #{payload['receiver_id']}"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    end
  end
end

# Example consumer that prints messages payloads
class ExampleConsumer < Karafka::BaseConsumer
  def consume
    messages.each { |message| puts message.payload }
  end

  # Run anything upon partition being revoked
  # def revoked
  # end

  # Define here any teardown things you want when Karafka server stops
  # def shutdown
  # end
end

class KarafkaApp < Karafka::App
  setup do |config|
    config.client_id = 'ruby-daemon-consumer'
    config.kafka = { 'bootstrap.servers': 'kafka-broker:29092' }
    config.client_id = 'standalone_notification_app'
    config.group_id = 'standalone_notification_app_consumer'
  end

  Karafka.monitor.subscribe(
    Karafka::Instrumentation::LoggerListener.new(
      # Karafka, when the logger is set to info, produces logs each time it polls data from an
      # internal messages queue. This can be extensive, so you can turn it off by setting below
      # to false.
      log_polling: true
    )
  )

    Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      # Log producer operations using the Karafka logger
      Karafka.logger,
      # If you set this to true, logs will contain each message details
      # Please note, that this can be extensive
      log_messages: true
    )
  )

  routes.draw do
      # Define a consumer group.
      # We'll use a new group ID to distinguish it from the Rails Karafka consumer.\
      # Subscribe to all three notification topics
      topic(:notification_producer_email) { consumer NotificationsConsumer }
      topic(:notification_producer_sms) { consumer NotificationsConsumer }
      topic(:notification_producer_push_notification) { consumer NotificationsConsumer }
  end
end
