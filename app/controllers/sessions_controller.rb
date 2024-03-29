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
        if Community.count > 0
          # First community must be the default, public community
          session[:community] = Community.first.id
          @user.member_of!(session[:community])
        else
          redirect_to new_community_path
        end
      end
    else
      sign_in user
      if user.member_of_any_community?
        session[:community] ||= user.first_community.community_id
      elsif Community.count > 0
        session[:community] = Community.first.id
        @user.member_of!(session[:community])
      end
    end
    session[:apply_filter_qualifier] = false
    @community = Community.find_by_id(session[:community])
    if @community.stacks.count > 0
      @stack ||= @community.stacks.find_by_sotd("1")
      @stack ||= @community.stacks.first
      session[:stack] = @stack.id
      if @stack.answered?(current_user)
        redirect_to stack_path(@stack)
      else
        redirect_to new_stack_response_path(session[:stack])
      end
    else
      redirect_to new_stack_path
    end
  end
    
  def destroy
    sign_out
    redirect_to 'http://www.heystack.com'
  end
  
end
