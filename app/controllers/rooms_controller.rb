class RoomsController < ApplicationController
  before_action :set_room, only: %i[show destroy]

  def index
    @rooms = Room.all
    @room = Room.new
  end

  def show
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to room_path(@room), notice: 'Новая комната создана'
    else
      flash.now[:alert] = 'Не удалось создать комнату. Укажите имя комнаты.'
      @rooms = Room.all
      render :index
    end
  end

  def destroy
    @room.destroy

    redirect_to root_path, notice: 'Комната успешно удалена'
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
