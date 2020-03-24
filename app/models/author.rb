class Author < ApplicationRecord
  after_create :set_image_path
  has_attached_file :image, styles: { medium: '250x300>' }, :storage => :cloudinary,:path => ':id/:style/:filename'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  has_many :books, dependent: :destroy



  def set_image_path
    self.image_url = self.image.url
    self.save   
  end
end
