class Stack < ActiveRecord::Base
  def answered?(user)
    self.responses.find_by_user(user)
  end
end
