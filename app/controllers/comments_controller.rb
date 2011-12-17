class CommentsController < ApplicationController
  def create
    @stack = Stack.find_by_id(session[:stack])
    @comment = @stack.comments.build(params[:comment])
    if @comment.save
      redirect_to @stack
    else
      flash[:error] = "Comment not saved!"
      redirect_to @stack
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment
      @stack = Stack.find_by_id(@comment.stack_id)
      flash[:notice] = "Comment deleted."
      @comment.destroy
      redirect_to @stack
    else
      redirect_to root_path
    end
  end

end
