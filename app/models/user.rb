class User < ApplicationRecord
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_attached_file :avatar, styles: { medium: '100x100>', thumb: '59x59>' },
                             default_url: 'https://res.cloudinary.com/dbqes9wsk/image/upload/v1585050544/defaults/missing_lmgsmf.png', storage: :cloudinary, path: ':id/:style/:filename'
  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\z}
  after_create :set_image_path

  def username
    email.split('@').first
  end

  def self.current
    Thread.current[:user]
  end

  def set_image_path
    unless image_url
      self.image_url = avatar.url
      self.save
    end
  end

  def self.current=(user)
    Thread.current[:user] = user
  end
end
