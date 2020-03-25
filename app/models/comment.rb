class Comment < ApplicationRecord
  has_attached_file :image, styles: { medium: '250x300>' }
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
  validates :body, presence: true, allow_blank: false

  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  belongs_to :user, optional: true
  belongs_to :book, optional: true
end
