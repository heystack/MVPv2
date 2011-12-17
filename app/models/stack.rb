class Stack < ActiveRecord::Base
  attr_accessible :name, :question, :stem, :sotd, :created_by
  attr_accessible :madlibs_intro, :madlibs_label, :madlibs_units
  attr_accessible :attr_biggest_desc, :attr_lowest_desc, :attr_lowest_legend, :attr_comparison_text
  attr_accessible :attr_email_buttons, :attr_email_units
  
  has_many   :responses,  :dependent => :destroy
  has_many   :comments,   :dependent => :destroy
  
  def created_by?(user)
    user == User.find_by_id(self.created_by)
  end

  def answered?(user)
    self.responses.find_by_user_id(user.id)
  end

  def tipped?
    count = self.responses.count
    (count / TIPPING_POINT ) >= 1
  end

  def comments?
    self.comments.count > 0
  end

end
