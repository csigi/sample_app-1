# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_remember_token  (remember_token)
#

class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :name, :email, :password, :password_confirmation

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, foreign_key: "follower_id",
                                  class_name: "Relationship",
                                  dependent: :destroy
  has_many :followed_users, through: :active_relationships, source: :followed
  has_many :passive_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  before_save :reformat_email
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end

  def feed
    Micropost.from_users_actively_followed_by(self)
  end

  def following?(other_user)
    active_relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    active_relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def reformat_email
      self.email.downcase!
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
