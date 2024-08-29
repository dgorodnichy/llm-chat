class ChatController < ApplicationController
  def index; end

  def create
    llm_service = LlmService.new("http://localhost:11434/api/generate")

    llm_service.fetch_response(params[:chat][:query]) do |chunk|
      # Обработка каждой части ответа
      puts "Получена часть: #{chunk}"
        # Здесь можно делать broadcast через ActionCable или другую обработку

        parsed_response = JSON.parse(chunk)

        ActionCable.server.broadcast(
          "chat_channel",
          { message: parsed_response['response'], done: parsed_response['done'] }
        )


    end

    head :ok
  end
end
