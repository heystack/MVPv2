class CommentsController < ApplicationController
  before_filter :admin_user, :only => :stkcomments

  def create
    @stack = Stack.find_by_id(session[:stack])
    @comment = @stack.comments.build(params[:comment])
    if @comment.save
      if !params[:user][:name].nil?
        @user = User.find_by_id(params[:comment][:user_id])
        @name = params[:user][:name]
        @email = params[:user][:email]
        @user.update_attributes(:name => @name, :email => @email)
      end
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
      @comment.destroy
      flash[:notice] = "Comment deleted."
      redirect_to @stack
    else
      redirect_to root_path
    end
  end

  def stkcomments
    if current_user.admin?
      @stacks = Stack.select("id, name").group('id', 'name')
      if params[:stack_id]
        @stack = Stack.find_by_id( params[:stack_id] )
        @comments = @stack.comments.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
        @count = @comments.count
      else
        @comments = Comment.paginate(:page => params[:page], :per_page => 100, :order => 'id DESC')
        @count = Comment.count
      end
    else
      flash[:error] = "You do not have permission."
      redirect_to root_path
    end
  end

end
