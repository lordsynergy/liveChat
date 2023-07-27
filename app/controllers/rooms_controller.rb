class RoomsController < ApplicationController
  before_action :set_room, only: %i[show destroy]

  def index
    @rooms = Room.where(is_private: false)
    @room = Room.new

    if current_user.nil?
      @users = User.all
    else
      @users = User.where.not(id: current_user.id)
    end
  end

  def show
    @user = @room.users.where.not(id: current_user.id).first

    if @room.is_private? && !@room.users.include?(current_user)
      redirect_to root_path, alert: 'You do not have access to this private room.'
    end
  end

  def create
    @room = current_user.rooms.build(room_params)

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

  def private_room_with_user
    @user = User.find(params[:user_id])
    @room_name = get_name(@user, current_user)
    @room = Room.where(name: @room_name).first || Room.create_private_room(@user, current_user, @room_name)

    redirect_to room_path(@room)
  end

  private

  def set_room
    @room = Room.find(params[:id])
    redirect_to root_path if @room.nil?
    @room
  end

  def room_params
    params.require(:room).permit(:name, :is_private, :user_id)
  end

  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end
end
