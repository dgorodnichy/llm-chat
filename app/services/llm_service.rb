require 'net/http'

class LlmService
  def initialize(api_endpoint)
    @api_endpoint = api_endpoint
  end

  def fetch_response(prompt, &block)
    Thread.new do
      uri = URI(@api_endpoint)
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = { model: "llama3", prompt: prompt }.to_json

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(req) do |response|
          response.read_body do |chunk|
            block.call(chunk)
          end
        end
      end
    end
  end
end
