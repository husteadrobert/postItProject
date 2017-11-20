class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(params.require(:comment).permit(:body))
    @comment.post = @post
    #@comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = User.find(session[:user_id])
    if @comment.save
      flash[:notice] = "Comment Added Successfully"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    vote = Vote.create(voteable: Comment.find(params[:id]), creator: current_user, vote: params[:vote])
    if vote.errors.any?
      flash[:error] = "Error Processing your Vote"
    else
      flash[:notice] = "Vote accepted"
    end

    redirect_to :back
  end
end