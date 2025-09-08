# ruby_daemon_consumer/consumer_daemon.rb

require 'kafka'
require 'daemons'
require 'json'

STDOUT.sync = true

Daemons.run_proc('notification_consumer') do
  puts "💎 Ruby Daemon Consumer started..."

  begin
    kafka_brokers = ENV.fetch('KAFKA_BROKERS', 'kafka-broker:29092').split(',')

    kafka = Kafka.new(
      seed_brokers: kafka_brokers,
      client_id: 'ruby-daemon-consumer'
    )

    consumer = kafka.consumer(group_id: 'ruby_daemon_group')

    # --- THIS IS THE FIX ---
    # The ruby-kafka gem requires subscribing to each topic in a separate call.
    # We can loop through an array of topics to do this cleanly.
    topics = [
      'notification_producer_email',
      'notification_producer_sms',
      'notification_producer_push_notification'
    ]
    topics.each { |topic| consumer.subscribe(topic) }
    # --- END OF FIX ---

    trap('TERM') { consumer.stop }

    consumer.each_message do |message|
      payload = JSON.parse(message.value)

      puts "\n~~~~~~~~~~~~~~ 💎 RUBY DAEMON RECEIVED ~~~~~~~~~~~~~~"
      puts "Topic: #{message.topic}"
      puts "Action Maker: #{payload['action_maker']}"
      puts "Message: '#{payload['message']}'"
      puts "Receiver ID: #{payload['receiver_id']}"
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    end

  rescue Kafka::Error => e
    puts "Kafka Error: #{e}"
    exit 1
  end
end
