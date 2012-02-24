class UserCommunitiesController < ApplicationController
  def create
  end

  def destroy
    UserCommunity.find(params[:id]).destroy
    flash[:success] = "User removed from community."
    redirect_to users_path
  end

end
