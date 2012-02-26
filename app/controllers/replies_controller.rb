class RepliesController < ApplicationController
  def new
    @comment = Comment.find_by_id(params[:reply][:comment_id])
    @reply = Reply.new
    @stack = Stack.find_by_id(session[:stack])
    respond_to do |format|
      format.html { redirect_to(@stack, :notice => 'Hello.') }
      format.js
    end
  end
  
  def create
    @comment = Comment.find_by_id(params[:reply][:comment_id])
    @reply = @comment.replies.build(params[:reply])
    if @reply.save
      if !params[:user][:name].nil?
        @user = User.find_by_id(params[:reply][:user_id])
        @name = params[:user][:name]
        @user.update_attributes(:name => @name)
      end
      # Notify comment author of reply
      MvpMailer.reply_to_comment(@comment, @reply).deliver
    else
      flash[:error] = "Reply not saved!"
    end
    @stack = Stack.find_by_id(session[:stack])
    respond_to do |format|
      format.html { redirect_to @stack }
      format.js
    end
  end

  def destroy
    @reply = Reply.find(params[:id])
    if @reply
      @comment = Comment.find_by_id(@reply.comment_id)
      @stack = Stack.find_by_id(@comment.stack_id)
      @reply.destroy
      flash[:notice] = "Reply deleted."
      redirect_to @stack
    else
      redirect_to root_path
    end
  end

end
