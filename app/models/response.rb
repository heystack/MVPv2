class Response < ActiveRecord::Base
  attr_accessible :user_id, :stack_id, :qualifier1, :value
  
  validates :value, :presence => true
  validates :user_id, :presence => true
  validates :stack_id, :presence => true

  belongs_to :stack
  belongs_to :user
  
  def all_neighbors
    Response.average(:value)
  end
  
end
