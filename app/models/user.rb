class User < ActiveRecord::Base
  include Slugable

  has_many :posts, foreign_key: :user_id
  has_many :comments, foreign_key: :user_id
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 3}, on: :create

  set_slugable_column :username

  def admin?
    self.role == "admin"
  end

  
end