class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    if user_signed_in?
      @posts = Post.includes(:user).order(created_at: :desc)
    else
      @posts = Post.select(:id, :title, :body, :created_at).order(created_at: :desc)
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user  # automatically assign author

    if @post.save
      redirect_to posts_path, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
