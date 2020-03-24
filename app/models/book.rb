class Book < ApplicationRecord
  

  scope :by_both, -> (search) { where("author_name LIKE ? OR title LIKE ?", "%#{search}%", "%#{search}%") }
  after_create :set_image_path

   
  has_attached_file :image, styles: { medium: '250x300>' }, :storage => :cloudinary,:path => ':id/:style/:filename'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  belongs_to :author
  has_many :reviews
  has_many :comments

  def set_image_path
    self.image_url = self.image.url
  self.save
    
    
  end

end
