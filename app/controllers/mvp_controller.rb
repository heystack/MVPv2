class MvpController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def send_comment
    @contact = params[:contact]
    MvpMailer.comment_email(@contact).deliver
    flash[:success] = "Thanks for the comment!"
    redirect_to root_path
  end

  def stack_request
    @request = params[:request]
    MvpMailer.stack_request_email(@request).deliver
    flash[:success] = "Thanks for the stack request! If you provided your email, we'll get back to you shortly."
    redirect_to root_path
  end

  def share_with_neighbor
    @contact = params[:contact]
    @stack = Stack.find_by_id(session[:stack])
    @from_name = @contact[:from_name]
    @user_email = @contact[:user_email]
    MvpMailer.email_neighbor(@stack, @contact, @from_name, @user_email).deliver
    flash[:success] = "Thanks for sharing with #{@contact[:email]}. Feel free to share with as many people as you\'d like!"
    redirect_to root_path
  end

end
