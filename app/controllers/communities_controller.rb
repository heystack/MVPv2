class CommunitiesController < ApplicationController
  before_filter :admin_user

  def index
    @title = "Heystack Communities"
    @communities = Community.all
  end

  def show
    @community = Community.find(params[:id])
    @title = @community.name
    @stacks = @community.stacks
    @users = @community.members.all.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
  end

  def edit
    @community = Community.find(params[:id])
    @title = @community.name
    @stacks = @community.stacks
  end

  def update
    @community = Community.find(params[:id])
    if @community.update_attributes(params[:community])
      flash[:success] = "Community Updated!"
      redirect_to community_path(@community.id)
    else
      @title = "Edit Community"
      render 'edit'
    end
  end

  def new
    @community = Community.new
    @title = "Create Community"
  end

  def create
    @community = Community.new(params[:community])
    if @community.save
      session[:community] = @community.id
      flash[:success] = "Community Created!"
      redirect_to community_path(@community.id)
    else
      @title = "Create Community"
      render 'new'
    end
  end

  def destroy
    Community.find(params[:id]).destroy
    flash[:success] = "Community deleted."
    redirect_to communities_path
  end

end
