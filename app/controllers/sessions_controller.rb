class SessionsController < ApplicationController
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
      @user.reset_session_token!
      login!(@user)
      redirect_to cats_url
    else
      @user = User.new(session_params)
      flash.now[:errors] = ["Invalid login credentials"]
      render :new
    end
  end

  private
  def session_params
    params.require(:session).permit(:user_name,:password)
  end
end
