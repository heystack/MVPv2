class VotesController < ApplicationController
  def create
    @comment = Comment.find_by_id(params[:vote][:comment_id])
    @vote = @comment.votes.build(:user_id => params[:vote][:user_id])
    @vote.save
    respond_to do |format|
      format.html { redirect_to(@stack) }
      format.js
    end
  end
  
  def destroy
    Vote.find(params[:id]).destroy
    flash[:success] = "Vote deleted."
    redirect_to stack_path(session[:stack])
  end
end
