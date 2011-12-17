class Response < ActiveRecord::Base
  attr_accessible :user_id, :stack_id, :qualifier1, :value

  belongs_to :stack
  belongs_to :user
  
  def all_neighbors
    Response.average(:value)
  end
  
end
