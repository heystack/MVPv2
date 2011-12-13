class MvpController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def send_comment
    @contact = params[:contact]
    MvpMailer.comment_email(@contact).deliver
    flash[:success] = "Thanks for the comment!"
    redirect_to root_path
  end

end
