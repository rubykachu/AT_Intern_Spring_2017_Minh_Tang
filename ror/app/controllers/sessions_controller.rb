class SessionsController < ApplicationController
  before_action :redirect_logged_in?, only: [:new, :create]
  def new
  	render 'new'
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      if user.activated?
  		log_in user
      params[:session][:remember_me] == '1' ? remember_helper(user) : forget_helper(user)
      redirect_back_or user
      # redirect_to user # redirect user_url(user)
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    def redirect_logged_in?
      redirect_to root_url if logged_in?
    end
end