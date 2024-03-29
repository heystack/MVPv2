class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :except => [:toggle_admin, :update]

  include ActionView::Helpers::TextHelper

  def new
  end

  def index
    @users = User.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
  end

  def show
    @user = User.find(params[:id])
    @responses = @user.responses.all(:order => 'id DESC')
  end

  def edit
    @user = User.find(params[:id])
    # @user.update_attributes(params[:user])
    # redirect_to root_path
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # params[:user][:subscribed] true if coming from weekly stack signup
      if params[:user][:subscribed]
        flash[:notice] = "You're in.  We'll dispatch a fresh new stack question each week to #{params[:user][:email]}!"
        MvpMailer.subscribe_email(@user).deliver
      end
      @stack = Stack.find_by_id(session[:stack])
      if params[:user_community]
        @updated_community = params[:user_community][:community]
        session[:community] = @updated_community
      end
      unless @updated_community.nil?
        if @user.member_of?(@updated_community)
          flash[:notice] = "Session switched to the " + Community.find(@updated_community).name + " community."
        else
          @relationship = @user.member_of!(params[:user_community][:community])
          flash[:notice] = (@user.name? ? @user.name : "") + " is now a member of the " + Community.find(@updated_community).name + " community."
        end
        redirect_to root_path and return
      end
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
    if params[:pin]
      if params[:pin] == '3822'
        @user.toggle!(:admin)
        flash[:success] = "Admin toggled."
      else
        flash[:success] = "Permission denied."
      end
    else
      @user.toggle!(:admin)
      flash[:success] = "Admin toggled."
    end
    redirect_to users_path
    # Ajax version not working
    # respond_to do |format|
    #   # redirect_to does not seem to be working, so used document.location in toggle_admin.js.erb...seems messy
    #   format.html { redirect_to "www.google.com" }
    #   format.js
    # end
  end
  
  def show_ghosts
    @ghosts = User.ghosts.older_than_5_mins.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
  end
  
  def delete_ghosts
    @count = User.ghosts.older_than_5_mins.count
    @users = User.ghosts.older_than_5_mins.destroy_all
    flash[:notice] = "Destroyed " + pluralize(@count, "ghost")
    redirect_to users_path
  end
  
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end

end
