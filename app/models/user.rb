class User < ApplicationRecord
 
  acts_as_token_authenticatable 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_attached_file :avatar, styles: { medium: '100x100>', thumb: '59x59>' },
  default_url: '/assets/missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def username
    email.split('@').first
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end


end
