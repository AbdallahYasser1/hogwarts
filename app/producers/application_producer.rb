class ApplicationProducer
  def self.call(*args)
    new.call(*args)
  end

  def call(payload)
    Karafka.producer.produce_async(
      topic: self.class.name.underscore.gsub("_producer", ""),
      payload: payload.to_json
    )
  end
end
