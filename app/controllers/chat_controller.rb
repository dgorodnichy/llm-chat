class ChatController < ApplicationController
  def index; end

  def create
    LlmJob.perform_later("http://localhost:11434/api/generate", params[:chat][:query])

    head :ok
  end
end
