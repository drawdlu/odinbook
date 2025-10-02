module Streamable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
  end

  def get_user_stream(post)
    user = post.user
    user.followers + [ user ]
  end
end
