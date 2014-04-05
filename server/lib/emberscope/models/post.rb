class Post < ActiveRecord::Base
  before_create :set_uuid
  has_many :votes

  def set_uuid
    self.uuid ||= SecureRandom.hex(16)
  end

  def exclusive_vote_count(user)
    votes.where.not(user_id: user.id).count
  end

  def has_voted?(user)
    votes.where(user_id: user.id).any?
  end
end

class PostSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :title, :url, :text
  attribute :uuid, key: :id
  attribute :exclusive_vote_count, key: :exclusiveVoteCount
  attribute :has_voted, key: :hasVoted

  def exclusive_vote_count
    if scope
      object.exclusive_vote_count(scope)
    else
      object.votes.count
    end
  end

  def has_voted
    !!(object.has_voted?(scope) if scope)
  end
end
