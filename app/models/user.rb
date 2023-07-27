class User < ApplicationRecord
  has_secure_password

  has_many :rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :interlocutors, dependent: :destroy
  has_many :private_rooms, through: :interlocutors, source: :room

  after_create_commit { broadcast_append_to 'users' }
end
