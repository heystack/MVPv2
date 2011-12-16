class ResponsesController < ApplicationController
  def new
    if !session[:stack]
      @stack = Stack.first
      session[:stack] = @stack.id
    else
      @stack = Stack.find_by_id(session[:stack])
    end
    session[:email] ||= "feedback@stkup.com"
    @email = session[:email]
    @response = @stack.responses.new
    @title = "New Response"
    @form_capable = true
    if session[:you]
      @ask_location = false
    else
      @ask_location = true
    end
    @host_url = request.host_with_port
    @base_url = "/stacks/" + @stack.id.to_s + "/responses"
    if @stack.name == "Babysitters"
      @response_value = session[:babysitters] ? ("%.2f" % session[:babysitters]).to_s.to_s.gsub(/.00/,"") : ""
    elsif @stack.name == "Mobilizers"
      @response_value = session[:mobilizers] ? ("%.f" % session[:mobilizers]).to_s.gsub(/.0/,"") : ""
    elsif @stack.name == "Homework"
      @response_value = session[:homework] ? ("%.1f" % session[:homework]).to_s.gsub(/.0/,"") : ""
    end
  end

  def create
    @stack = Stack.find_by_id(session[:stack])
    @response = @stack.responses.build(params[:response])
    @user = User.find_by_id(@response.user_id)
    if @response.save
      @user.update_attributes(:zipcode => @response.zipcode)
      flash[:success] = "Response saved: " + @response.value.to_s + " user.id=" + @user.id
      session[:you] = @response.value
      session[:email] = @response.email
      session[:response_id] = @response.id
      session[:zipcode] = @response.zipcode
      
      if @stack.name == "Babysitters"
        session[:babysitters] = session[:you]
        session[:babysitter_id] = @response.id
      elsif @stack.name == "Mobilizers"
        session[:mobilizers] = session[:you]
        session[:mobilizers_id] = @response.id
      elsif @stack.name == "Homework"
        session[:homework] = session[:you]
        session[:homework_id] = @response.id
      end

      # Session vars must be set since we might be coming from an external form submission
      session[:stack] = @stack.id
      if session[:stack]
        redirect_to @stack
      else
        redirect_to root_path
      end
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
    @email = session[:email]
    @host_url = request.host_with_port
    @base_url = "/stacks/" + @stack.id.to_s + "/responses"
    if @stack.name == "Babysitters"
      @response_value = ("%.2f" % @response.value).to_s.gsub(/\.00/,"")
    elsif @stack.name == "Mobilizers"
      @response_value = ("%.1f" % @response.value).to_s.gsub(/\.0/,"")
    elsif @stack.name == "Homework"
      @response_value = ("%.1f" % @response.value).to_s.gsub(/\.0/,"")
    end
  end

  def update
    @response = Response.find(params[:id])
    @stack = Stack.find(@response.stack_id)
    session[:response_id] = @response.id
    if @response.update_attributes(params[:response])
      @zipcode = params[:user][:zipcode]
      current_user.update_attributes(:zipcode => @zipcode)
      session[:you] = @response.value
      session[:email] = params[:user][:email]
      session[:response_id] = @response.id
      session[:zipcode] = @zipcode

      if @stack.name == "Babysitters"
        session[:babysitter_pay_rate] = session[:you]
        session[:babysitter_id] = @response.id
      elsif @stack.name == "Mobilizers"
        session[:mobilizers] = session[:you]
        session[:mobilizers_id] = @response.id
      elsif @stack.name == "Homework"
        session[:homework] = session[:you]
        session[:homework_id] = @response.id
      end
      redirect_to @stack
    else
      flash[:error] = "Please enter a valid response."
      redirect_to edit_response_path(@response.id)
    end
  end

end
