class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @responses = @user.responses.all
  end

  def edit
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    redirect_to root_path
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Ok, you're all set to receive a new stack question each week sent to #{params[:user][:email]}!"
      @stack = Stack.find_by_id(session[:stack])
      redirect_to @stack
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
   
  def toggle_admin
    @user = User.find(params[:id])
    @user.toggle!(:admin)
    flash[:success] = "Admin toggled."
    redirect_to users_path
    # Ajax version not working
    # respond_to do |format|
    #   # redirect_to does not seem to be working, so used document.location in toggle_admin.js.erb...seems messy
    #   format.html { redirect_to "www.google.com" }
    #   format.js
    # end
  end
  
  def signup
    @user = User.find(params[:id])
    @user.update_attributes(:email => params[:user][:email])
  end
  
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end

end
