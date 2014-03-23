class Post < ActiveRecord::Base
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.hex(16)
  end
end

class PostSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :title, :url, :text
  attribute :uuid, key: :id
end
