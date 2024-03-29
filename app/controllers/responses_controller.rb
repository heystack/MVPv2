class ResponsesController < ApplicationController
  before_filter :admin_user, :only => :stkresponses
  before_filter :authorized_user, :only => [:edit, :destroy]

  def new
    if !session[:stack]
      if session[:community]
        @community = Community.find_by_id(session[:community])
        @stack = @community.first
      else
        @stack = Stack.first
        session[:stack] = @stack.id
        session[:community] = @stack.community_id
      end
    else
      @stack = Stack.find_by_id(session[:stack])
      session[:community] ||= @stack.community_id
    end
    @new_user = !( current_user.responses.count > 0 )
    @email = current_user.email ? current_user.email : "feedback@heystack.com"
    @response = @stack.responses.new
    @title = "New Response"
    @form_capable = true
    if session[:you]
      @ask_location = false
      @zipcode = current_user.zipcode
    else
      @ask_location = true
    end
    @host_url = request.host_with_port
    @base_url = "/stacks/" + @stack.id.to_s + "/responses"
    @previous_response = Response.find_by_stack_id_and_user_id(@stack.id, current_user.id)
    if @previous_response
      if @stack.attr_rounding == ".00"
        @response_value = ("%.2f" % @previous_response.value).to_s.gsub(/.00/,"")
      elsif @stack.attr_rounding == ".0"
        @response_value = ("%.1f" % @previous_response.value).to_s.gsub(/.0/,"")
      elsif @stack.attr_rounding == "."
        @response_value = ("%.f" % @previous_response.value).to_s.gsub(/.0/,"")
      end
    else
      @response_value = ""
    end
  end

  def create
    # Session issues with IE caused strange behavior, session[:debug1] often differs from session[:debug2]
    # @stack = Stack.find_by_id(session[:stack])
    # session[:debug1] = session[:stack]
    @stack = Stack.find_by_id(params[:response][:stack_id])
    session[:stack] = @stack.id
    # session[:debug2] = session[:stack]
    @response = @stack.responses.build(params[:response])
    @user = User.find_by_id(@response.user_id)
    # Check for outliers and alert
    if @stack.outlier?(@response.value, @response.qualifier1)
      flash[:error] = "Hmmm...may be an outlier answer. Give a 2nd look (we will too) and use <strong>refine my answer</strong> if need be.".html_safe
      MvpMailer.outlier_email(@stack, @response.value, @user).deliver
      @response.outlier = true
    else
      @response.outlier = false
    end
    if @response.save
      if (params[:user][:zipcode]).nil?
        @zipcode = @user.zipcode
      else
        @zipcode = params[:user][:zipcode]
        @user.update_attributes(:zipcode => @zipcode)
      end
      session[:you] = @response.value
      redirect_to @stack
    else
      flash[:error] = "You first need to enter a response!"
      redirect_to new_stack_response_path(@stack.id)
    end
  end

  def edit
    if !signed_in?
      redirect_to root_path
    end
    @response = Response.find(params[:id])
    @stack = Stack.find(@response.stack_id)
    if !@stack.answered?(current_user)
      flash[:error] = "You do not have permission."
      redirect_to root_path
    end
    session[:stack] = @stack.id
    @new_user = !( current_user.responses.count > 0 )
    @form_capable = true
    @ask_location = true
    @zipcode = current_user.zipcode
    @email = current_user.email
    @host_url = request.host_with_port
    @base_url = "/stacks/" + @stack.id.to_s + "/responses"
    if @stack.attr_rounding == ".00"
      @response_value = ("%.2f" % @response.value).to_s.gsub(/\.00/,"")
    elsif @stack.attr_rounding == ".0"
      @response_value = ("%.1f" % @response.value).to_s.gsub(/\.0/,"")
    elsif @stack.attr_rounding == "."
      @response_value = ("%.f" % @response.value).to_s.gsub(/.0/,"")
    else
      @response_value = ""
    end
  end

  def update
    @response = Response.find(params[:id])
    @stack = Stack.find(@response.stack_id)
    session[:stack] = @stack.id
    @user = User.find_by_id(@response.user_id)
    # Check for outliers and alert
    if @stack.outlier?(params[:response][:value].to_f, params[:response][:qualifier1])
      flash[:error] = "Hmmm...seems like an outlier answer. Give a 2nd look (we will too) and use <a href='#{url_for(edit_response_path(@response))}'>refine my answer</a> if need be.".html_safe
      MvpMailer.outlier_email(@stack, params[:response][:value], @user).deliver
      params[:response][:outlier] = true
    else
      params[:response][:outlier] = false
    end
    if @response.update_attributes(params[:response])
      @zipcode = params[:user][:zipcode]
      current_user.update_attributes(:zipcode => @zipcode)
      session[:you] = @response.value
      redirect_to @stack
    else
      flash[:error] = "Hmmm...seems like you forgot to fill in some info. We need a valid response to stack you up."
      redirect_to edit_response_path(@response.id)
    end
  end

  def index
    # Create new response from URL-based GET form submission
    # if !params[:response]
    #   redirect_to root_path and return
    # end
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
    @new_user = !( current_user.responses.count > 0 )
    if params[:email]
      current_user.update_attributes(:email => params[:email])
    end
    @stack = Stack.find_by_id(params[:stack_id])
    # Session vars must be set since we might be coming from an email form submission
    session[:stack] = @stack.id
    session[:apply_filter_qualifier] = false
    if @stack.answered?(current_user) && params[:response]
      @response = @stack.responses.find_by_user_id(current_user.id)
      @save_response = @response.update_attributes(params[:response])
    else
      redirect_to new_response_path and return
    end
    if @save_response
      session[:you] = @response.value
      if session[:stack]
        redirect_to edit_response_path(@response)
      else
        redirect_to root_path
      end
    else
      redirect_to new_response_path
    end
  end

  def destroy
    @response = Response.find(params[:id])
    flash[:notice] = "Response \##{@response.id} deleted."
    @response.destroy
    redirect_to root_path
  end

  def stkresponses
    if current_user.admin?
      @stacks = Stack.select("id, name").group('id', 'name')
      if params[:stack_id]
        @stack = Stack.find_by_id( params[:stack_id] )
        @responses = @stack.responses.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
        @count = @responses.count
      else
        @responses = Response.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
        @count = Response.count
      end
    else
      flash[:error] = "You do not have permission."
      redirect_to root_path
    end
  end

  private

    def authorized_user
      return true if current_user.admin?
      @response = current_user.responses.find_by_id(params[:id])
      redirect_to root_path if @response.nil?
    end

end
