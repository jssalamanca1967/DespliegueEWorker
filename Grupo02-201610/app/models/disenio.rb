class Disenio < ActiveRecord::Base
  belongs_to :proyecto
  self.per_page = 10
  mount_uploader :picture, PictureUploader
  validate :validate_minimum_image_size
  
  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  def validate_minimum_image_size
    image = MiniMagick::Image.open(picture.path)
    unless image[:width] > 800 || image[:height] > 600
      errors.add :image, "El tamaño minimo es de 800x600px"
    end
  end
end
