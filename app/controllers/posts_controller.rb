class PostsController < ApplicationController
  def index
    user_ids = current_user.followings.map(&:id) << current_user.id
    @posts = Post.includes(:user, :comments, :likes).where(user_id: user_ids).reverse_order
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build
    if post_params[:image]
      @post.postable = Picture.create(content: post_params[:image], alt: post_params[:content])
    else
      @post.postable = Text.create(post_params)
    end

    respond_to do |format|
      if @post.save
        format.turbo_stream
        format.html { redirect_to root_path }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])

    @post.destroy
  end

  def delete_button
    @post = Post.find(params[:id])

    render partial: "posts/link", locals: { post: @post }
  end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
