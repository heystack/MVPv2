class StacksController < ApplicationController
  def new
    if signed_in?
      @stack = Stack.new
      @title = "Create New Stack"
    else
      flash[:notice] = "You must first sign in order to create a new Stack Category."
      redirect_to root_path
    end
  end

  def create
    if signed_in?
      @stack = Stack.new(params[:stack])
      @stack.created_by = current_user.id
      if @stack.save
        flash[:success] = "Stack Created!"
        redirect_to @stack
      else
        @title = "Create a New Stack"
        render 'new'
      end
    else
      flash[:notice] = "You must first sign in order to create a new Stack."
      redirect_to root_path
    end
  end

  def show
    @stack = Stack.find_by_id(params[:id])
    @title = @stack.name
  end
end
