class User < ApplicationRecord
  has_secure_password

  has_many :room, dependent: :destroy
  has_many :messages, dependent: :destroy
end
