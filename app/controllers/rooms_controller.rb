class RoomsController < ApplicationController
  before_action :set_room, only: %i[show destroy]

  def index
    @rooms = Room.all
    @room = Room.new
    @users = User.all
  end

  def show
  end

  def create
    @room = current_user.room.build(room_params)

    if @room.save
      redirect_to room_path(@room), notice: 'New room created!'
      @room.broadcast_append_to :rooms
    else
      flash.now[:alert] = 'Failed to create a room. Enter the name of the room.'
      @rooms = Room.all
      render :index
    end
  end

  def destroy
    @room.broadcast_remove_to('rooms', target: "room_#{@room.id}")

    RoomChannel.room_deleted(@room.id, current_user.id)

    @room.destroy

    redirect_to root_path, notice: 'Room was successfully deleted'
  end

  private

  def set_room
    @room = Room.find(params[:id])
    redirect_to root_path if @room.nil?
    @room
  end

  def room_params
    params.require(:room).permit(:name)
  end
end
