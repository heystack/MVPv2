class Vote < ActiveRecord::Base
  attr_accessible :user_id, :comment_id, :type
  
  belongs_to :comment
  belongs_to :user

  validates :user_id,     :presence => true
  validates :comment_id,  :presence => true
end
