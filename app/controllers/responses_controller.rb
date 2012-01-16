class ResponsesController < ApplicationController

  def new
    if !session[:stack]
      @stack = Stack.first
      session[:stack] = @stack.id
    else
      @stack = Stack.find_by_id(session[:stack])
    end
    @email = current_user.email ? current_user.email : "feedback@stkup.com"
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
    @stack = Stack.find_by_id(session[:stack])
    @response = @stack.responses.build(params[:response])
    @user = User.find_by_id(@response.user_id)
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
    if @response.update_attributes(params[:response])
      @zipcode = params[:user][:zipcode]
      current_user.update_attributes(:zipcode => @zipcode)
      session[:you] = @response.value
      redirect_to @stack
    else
      flash[:error] = "Please enter a valid response."
      redirect_to edit_response_path(@response.id)
    end
  end

  def index
    # Create new response from URL-based GET form submission
    if !params[:response]
      redirect_to root_path and return
    end
    # Replication of first part of Sessions#Create - probably a better way to do this
    user = current_user
    if user.nil?
      @user = User.new
      if @user.save
        sign_in @user
      end
    else
      sign_in user
    end
    # end Sessions#Create snippet
    if params[:email]
      current_user.update_attributes(:email => params[:email])
    end
    @stack = Stack.find_by_id(params[:stack_id])
    # Session vars must be set since we might be coming from an email form submission
    session[:stack] = @stack.id
    if @stack.answered?(current_user)
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
      @responses = Response.all(:order => 'id DESC')
      @count = Response.count
      @stacks = Stack.select("id, name").group('id', 'name')
    else
      flash[:error] = "You do not have permission."
      redirect_to root_path
    end
  end

end
