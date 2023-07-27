class Room < ApplicationRecord
  belongs_to :user, optional: true
  has_many :messages, dependent: :destroy
  has_many :interlocutors, dependent: :destroy
  has_many :users, through: :interlocutors

  validates :name, presence: true

  def self.create_private_room(user, current_user, room_name)
    single_room = Room.create!(name: room_name, is_private: true)
    Interlocutor.create!(user_id: user.id, room_id: single_room.id)
    Interlocutor.create!(user_id: current_user.id, room_id: single_room.id)

    single_room
  end

  def unread_messages_from_user(user)
    messages.where(user: user, read: false).count
  end
end
