class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url
  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :password)

  end
end
