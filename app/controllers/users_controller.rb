class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :autorize_user, only: %i[ edit update destroy ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    session[:current_time] = Time.now
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.create(user_params)

    if @user.save
      redirect_to root_path, notice: 'You have successfully registered!'

      session[:user_id] = @user.id
      cookies.signed[:user_id] = @user.id
    else
      flash.now[:alert] = 'You have filled out the registration form fields incorrectly.'

      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'User data updated!'

      session[:user_id] = @user.id
    else
      flash.now[:alert] = 'Errors occurred while trying to save the user.'

      render :edit
    end
  end

  def destroy
    @user.destroy

    session.delete(:user_id)

    redirect_to root_path, notice: 'User deleted.'
  end

  private

  def autorize_user
    redirect_with_alert unless current_user == @user
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end
end
