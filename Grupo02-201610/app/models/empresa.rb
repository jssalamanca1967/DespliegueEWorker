class Empresa < ActiveRecord::Base
  has_many :proyectos
  has_secure_password
end
