require 'net/http'

class LlmJob < ApplicationJob
  queue_as :default

  def perform(api_endpoint, prompt)
    uri = URI(api_endpoint)
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = { model: "llama3", prompt: prompt }.to_json

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req) do |response|
        response.read_body do |chunk|
          parsed_response = JSON.parse(chunk)
          ActionCable.server.broadcast(
            "chat_channel",
            { message: parsed_response['response'], done: parsed_response['done'] }
          )
        end
      end
    end
  end
end
