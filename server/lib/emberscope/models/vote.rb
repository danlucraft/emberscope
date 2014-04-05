
class Vote < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  def client_side_id
    "#{post.uuid}-#{user.uuid}"
  end

  def self.for(post_uuid, user_uuid)
    if post = Post.where(uuid: post_uuid).first and user = User.where(uuid: user_uuid).first
      Vote.create!(post_id: post.id, user_id: user.id)
    end
  end

  def self.find_by_client_side_id(client_side_id)
    post_uuid, user_uuid = client_side_id.split("-")
    if post = Post.where(uuid: post_uuid).first and user = User.where(uuid: user_uuid).first
      Vote.where(post_id: post.id, user_id: user.id).first
    end
  end

  def post_uuid
    post.uuid
  end

  def user_uuid
    user.uuid
  end
end

