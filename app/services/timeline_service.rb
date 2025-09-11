require "net/http"
require "uri"
require "json"

class TimelineService
  BASE_URI = ENV.fetch("TIMELINE_SERVICE_URL", "http://localhost:3001")

  def self.get_user_timeline(user_id, limit = 20)
    # 1. Construct the full URI
    uri = URI("#{BASE_URI}/api/timelines/#{user_id}?limit=#{limit}")

    # 2. Make the GET request
    response = Net::HTTP.get_response(uri)

    # 3. Check if the response was successful (a 2xx status code)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      # Optionally log the failure reason
      Rails.logger.error "Timeline fetch failed: #{response.code} #{response.message}"
      []
    end
  # 4. Rescue from network errors (e.g., connection refused)
  rescue URI::InvalidURIError, JSON::ParserError, SocketError => e
    Rails.logger.error "Timeline fetch error: #{e.message}"
    []
  end
end
