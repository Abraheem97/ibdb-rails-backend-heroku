class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    
  end

  private 

  def render_message(message)
  	
  end
end
  