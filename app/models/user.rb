class User < ActiveRecord::Base
  has_many :groups
  has_many :expenses, :through => :groups

  has_secure_password

  PASSWORD_FORMAT = /\A
  (?=.{8,})          # Must contain 8 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
/x

  validates :username, presence: true,
                       uniqueness: true,
                       format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9\.-]+\.[A-Za-z]+\Z/ }
  validates :password, presence: true,
                       format: { with: PASSWORD_FORMAT }

  # validates_presence_of :username, :email, :password
  # validates_uniqueness_of :username, :email


end
