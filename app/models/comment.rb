class Comment < ActiveRecord::Base
  attr_accessible :user_id, :stack_id, :content, :votes

  belongs_to :stack
  belongs_to :user
  has_many   :replies, :dependent => :destroy
  has_many   :votes, :dependent => :destroy
  
  default_scope :order => 'comments.created_at DESC'
  
  def created_by?(user)
    user == User.find_by_id(self.user_id)
  end

end
