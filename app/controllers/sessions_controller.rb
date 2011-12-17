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
      @stack ||= Stack.find_by_sotd("1")
      @stack ||= Stack.first
      session[:stack] = @stack.id
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
    redirect_to signed_out_path
  end
  
end
