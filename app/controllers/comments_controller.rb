class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @post = Post.find(params[:post_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { render root_path }
      else
        format.html { render :new, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    @comment.delete

    respond_to do |format|
      format.turbo_stream
      format.html { render rooth_path }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end
end
