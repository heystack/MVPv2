class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :zipcode

  has_many :responses # No :dependent => :destroy (Responses survive user destroy)
  has_many :comments, :dependent => :destroy
  
  before_save :make_salt

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    user && user.has_password?(submitted_password) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private
  
    def make_salt
      self.salt = secure_hash("#{Time.now.utc}--#{password}") if new_record?
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
