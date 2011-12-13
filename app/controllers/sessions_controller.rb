class SessionsController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mailer
  # TODO: Figure out how to remove this line!
  skip_before_filter :verify_authenticity_token

  def new
    @title = "Sign in"
  end
  
  def create
    if existing_user?
      if Stack.count > 0
        session[:stack] ||= Stack.find_by_sotd('1')
        redirect_to new_stack_response_path(session[:stack])
      else
        redirect_to new_stack_path
      end
    else
      @user = User.new
      if @user.save
        sign_in @user
        redirect_to @user
      end
    end
  end
    
  def destroy
    sign_out
    redirect_to root_path
  end
  
end
