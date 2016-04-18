class Proyecto < ActiveRecord::Base
  belongs_to :empresa
  has_many :disenios
  self.per_page = 10
end
