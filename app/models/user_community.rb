class UserCommunity < ActiveRecord::Base
  attr_accessible :community_id, :user_id

  belongs_to :user
  belongs_to :community
  
  validates :user_id,       :presence => true
  validates :community_id,  :presence => true
end
