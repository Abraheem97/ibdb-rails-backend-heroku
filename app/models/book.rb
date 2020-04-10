class Book < ApplicationRecord
  
  scope :by_both, ->(search) { where('lower(author_name) LIKE ? OR lower(title) LIKE ?', "%#{search}%", "%#{search}%") }
  after_create :set_image_path

  has_attached_file :image, styles: { medium: '250x300>' }, storage: :cloudinary, path: ':id/:style/:filename'
  validates_attachment_content_type :image, content_type: %r{\Aimage/.*\Z}
  belongs_to :author
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy

  def set_image_path
    if image_url
      require 'open-uri'
      if image_url != ''
        self.image = open(self.image_url)
        save
      end
    else
      self.image_url = image.url
      save
    end
  end
end
