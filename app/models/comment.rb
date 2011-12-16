class Comment < ActiveRecord::Base
  attr_accessible :user_id, :stack_id, :content, :votes

  belongs_to :stack
  belongs_to :user
end
