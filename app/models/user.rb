class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :zipcode, :subscribed

  has_many :responses # No :dependent => :destroy (Responses survive user destroy)
  has_many :comments
  has_many :user_communities, :dependent => :destroy
  has_many :communities, :through => :user_communities
  has_many :votes
  
  scope :ghosts, where(:responses_count => 0)
  scope :older_than_5_mins, :conditions => {:created_at => 1.year.ago..5.minutes.ago}
  
  before_save :make_salt

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    user && user.has_password?(submitted_password) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def make_admin
    self.admin = true unless !current_user.admin?
  end

  # communities through the user_communities association
  def member_of_any_community?
    self.user_communities.count > 0
  end

  def most_recent_community
    self.user_communities.last
  end

  def first_community
    self.user_communities.first
  end

  def member_of?(community)
    self.user_communities.find_by_community_id(community)
  end

  def member_of!(community)
    self.user_communities.create!(:community_id => community)
  end
  
  def not_member_of!(community)
    self.user_communities.find_by_community_id(community).destroy
  end

  def voted_for(comment)
    self.votes.find_by_comment_id(comment)
  end

  private
  
    def make_salt
      self.salt = secure_hash("#{Time.now.utc}--#{password}") if new_record?
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
