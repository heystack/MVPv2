class Community < ActiveRecord::Base
  attr_accessible :name, :desc, :logo, :type

  has_many :reverse_user_communities,
            :foreign_key => "community_id",
            :class_name => "UserCommunity",
            :dependent => :destroy
  has_many :members,
            :through => :reverse_user_communities,
            :source => :user
  has_many :stacks, :dependent => :destroy
end
