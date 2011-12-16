class SessionsController < ApplicationController
  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mailer
  # TODO: Figure out how to remove this line!
  skip_before_filter :verify_authenticity_token

  def new
    @title = "Sign in"
  end
  
  def create
    user = current_user
    if user.nil?
      @user = User.new
      if @user.save
        sign_in @user
      end
    else
      sign_in user
    end
    if Stack.count > 0
      session[:stack] ||= Stack.find_by_sotd("1").id
      session[:stack] ||= Stack.first
      @stack = Stack.find_by_id(session[:stack])
      if @stack.answered?(current_user)
        redirect_to edit_stack_response_path(@stack, @stack.answered?(current_user))
      else
        redirect_to new_stack_response_path(session[:stack])
      end
    else
      redirect_to new_stack_path
    end
  end
    
  def destroy
    sign_out
    redirect_to root_path
  end
  
end
