class UsersController < ApplicationController
  before_action :get_user, only: [:edit, :show, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :password, :time_zone))
    if @user.save
      flash[:notice] = "New Users Registered Successfully"
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    @user.update(params.require(:user).permit(:username, :password, :time_zone))
    if @user.save
      flash[:notice] = "Profile Updated Successfully"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
    def get_user
      @user = User.find_by(slug: params[:id])
    end

    def require_same_user
      if current_user != @user
        flash[:error] = "You're not allowed to do that"
        redirect_to root_path
      end
    end


end