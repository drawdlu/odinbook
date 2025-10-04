class PostsController < ApplicationController
  def index
    user_ids = current_user.followings.map(&:id) << current_user.id
    @posts = Post.includes(:user, :comments, :likes).where(user_id: user_ids).reverse_order
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream
        format.html { redirect_to root_path }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :image)
  end
end
