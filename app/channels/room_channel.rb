class RoomChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to RoomChannel, roomId: #{params[:roomId]}"

    @room = Room.find(params[:roomId])

    stream_from "room_channel_#{@room.id}"
  end

  def unsubscribed
    logger.info "Unsubscribed from RoomChannel"
    stop_stream_from @room
  end

  def speak(data)
    logger.info "RoomChannel, speak: #{data.inspect}"

    MessageService.new(body: data['message'], user: current_user, room: @room).perform
  end

  def self.room_deleted(room_id, user_id)
    ActionCable.server.broadcast("room_channel_#{room_id}", { action: 'room_deleted', user_id: user_id })
  end
end
