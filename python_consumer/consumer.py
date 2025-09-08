import json
import os
from confluent_kafka import Consumer, KafkaException

# Configuration for the Kafka consumer
config = {
    # This address 'kafka-broker:29092' is correct for container-to-container communication.
    'bootstrap.servers': os.environ.get('KAFKA_BROKERS', 'localhost:9092'),
    # A unique group ID ensures this consumer group is separate from the Karafka one.
    'group.id': 'python_notifications_group',
    'auto.offset.reset': 'earliest'
}

# Create a new consumer instance
consumer = Consumer(config)

# Subscribe to all three notification topics
topics = [
    'notification_producer_email',
    'notification_producer_sms',
    'notification_producer_push_notification'
]
consumer.subscribe(topics)

print("🐍 Python Notification Consumer started...")

try:
    while True:
        # Poll for new messages
        msg = consumer.poll(1.0)

        if msg is None:
            continue
        if msg.error():
            raise KafkaException(msg.error())
        else:
            # Decode the message and parse the JSON payload
            payload = json.loads(msg.value().decode('utf-8'))
            
            # Print a formatted output to the console
            print(
                f"\n~~~~~~~~~~~~~~ 🐍 PYTHON CONSUMER RECEIVED ~~~~~~~~~~~~~~"
                f"\nTopic: {msg.topic()}"
                f"\nAction Maker: {payload.get('action_maker')}"
                f"\nMessage: '{payload.get('message')}'"
                f"\nReceiver ID: {payload.get('receiver_id')}"
                f"\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
            )

except KeyboardInterrupt:
    print("Stopping Python consumer.")
finally:
    # Cleanly close the consumer connection
    consumer.close()