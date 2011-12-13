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

  def show
    @title = "Show Stack"
  end
end
