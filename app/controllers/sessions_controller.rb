class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      session_params[:user_name],
      session_params[:password]
    )

    if @user
      login!(@user)
      redirect_to cats_url
    else
      @user = User.new(session_params)
      flash.now[:errors] = ["Invalid login credentials"]
      render :new
    end
  end

  def destroy
    if current_user
      Session.find_by_session_token(session[:session_token]).destroy
    end
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private
  def session_params
    params.require(:session).permit(:user_name,:password)
  end
end
