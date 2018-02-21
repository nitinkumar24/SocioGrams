class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :replies, dependent: :destroy
  validates :content, presence: true, length: {maximum: 400}
  after_create :add_mentions

  def add_mentions
      Mention.create_from_text(self)
  end

  def can_delete user
      self.user_id == user.id or self.post.user_id == user.id
  end

    def can_update user
        self.user_id == user.id
    end
end