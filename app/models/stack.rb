class Stack < ActiveRecord::Base
  attr_accessible :name, :question, :stem, :sotd, :created_by
  attr_accessible :madlibs_intro, :madlibs_label, :madlibs_units
  attr_accessible :attr_biggest_desc, :attr_lowest_desc, :attr_lowest_legend, :attr_comparison_text
  attr_accessible :attr_email_buttons, :attr_email_units, :attr_email_message
  attr_accessible :attr_type, :attr_tooltip_prefix, :attr_tooltip_units, :attr_rounding
  attr_accessible :attr_comparison_1, :attr_comparison_2
  attr_accessible :madlibs_1, :madlibs_1_type, :madlibs_1_label, :madlibs_1_option_1, :madlibs_1_option_2, :madlibs_1_option_3, :madlibs_1_option_4, :madlibs_1_option_5, :madlibs_1_option_6, :madlibs_1_option_7, :madlibs_1_option_8, :madlibs_1_option_9, :madlibs_1_option_10, :madlibs_1_option_11, :madlibs_1_option_12
  attr_accessible :madlibs_2, :madlibs_2_label
  attr_accessible :madlibs_3
  attr_accessible :community_id

  has_many   :responses,  :dependent => :destroy
  has_many   :comments,   :dependent => :destroy
  belongs_to :community
  
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
