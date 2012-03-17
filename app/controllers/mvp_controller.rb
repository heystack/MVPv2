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
    flash[:success] = "Your stack request is in. Expect confirmation and sharing tips shortly. Comments on the submission process? <a href='#comments', rel='facebox'>Tell us</a>.".html_safe
    @stack = Stack.find_by_id(session[:stack])
    redirect_to @stack
  end

  def f69b29082d4aabb4
  end

  def share_form
    @stack = Stack.find_by_id(session[:stack])
  end

  def howitworks
    # Replication of first part of Sessions#Create - probably a better way to do this
    @user = current_user
    if @user.nil?
      @user = User.new
      if @user.save
        sign_in @user
        if Community.count > 0
          if params[:community]
            session[:community] = params[:community]
          else
            # First community must be the default, public community
            session[:community] = Community.first.id
          end
          @user.member_of!(session[:community])
        end
      end
    else
      sign_in @user unless signed_in?
      if params[:community]
        session[:community] = params[:community]
        if !@user.member_of?(session[:community])
          @user.member_of!(session[:community])
        end
      else
        if @user.member_of_any_community?
          session[:community] ||= @user.first_community.community_id
        elsif Community.count > 0
          session[:community] = Community.first.id
          @user.member_of!(session[:community])
        end
      end
    end
    # end Sessions#Create snippet
  end

  def share_via_email
    @contact = params[:contact]
    @stack = Stack.find_by_id(session[:stack])
    @from_name = @contact[:from_name]
    @user_email = @contact[:user_email]
    MvpMailer.email_neighbor(@stack, @contact, @from_name, @user_email).deliver
    flash[:success] = "Stack shared with #{@contact[:email]}. More answers \= better info so share on! Comments on sharing process? <a href='#comments', rel='facebox'>Tell us</a>.".html_safe
    redirect_to @stack
  end

  def signedout
  end
  
end
