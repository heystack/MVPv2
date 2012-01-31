class Reply < ActiveRecord::Base

  belongs_to :comment
  belongs_to :user

  default_scope :order => 'replies.created_at DESC'
  
  def created_by?(user)
    user == User.find_by_id(self.user_id)
  end

end
