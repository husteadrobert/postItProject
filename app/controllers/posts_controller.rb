class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:show, :index]
  before_action :require_permission, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
    respond_to do |format|
      format.html
      format.json { render json: @posts, only: [:title, :url] }
    end
  end

  def show
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.json do
        comment_list = []
        @post.comments.each do |comment|
          entry = {body: comment.body, user: comment.creator.username}
          comment_list.push(entry)
        end
        render json: comment_list
      end
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = User.find(session[:user_id])

    if @post.save
      flash[:notice] = "Your Post was Created Successfully"
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @post.update(post_params)
    if @post.save
      flash[:notice] = "Your Post was Edited Successfully"
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def vote
    vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  private

    def set_post
      #@post = Post.find(params[:id])
      @post = Post.find_by(slug: params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :url, :description, category_ids: [])
    end

    def require_permission
      access_denied unless logged_in? && (current_user.admin? || current_user == @post.creator)
    end
end
