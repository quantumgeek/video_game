# == Schema Information
# Schema version: 20110701010547
#
# Table name: users
#
#  id            :integer         not null, primary key
#  username      :string(255)
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  admin         :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password
  
  # Encrypt the password before it is saved in the database
  before_save :encrypt_password
  
  # Simple match for email addresses
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :username,  :presence => true,
                        :length => { :within => 3..20 },
                        :uniqueness => { :case_sensitive => false }
  validates :email,     :presence => true,
                        :format => { :with => email_regex},
                        :uniqueness => { :case_sensitive => false }
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40 }
  
  
  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash  == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  private
    def encrypt_password
      if password.present?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      end
    end
end
