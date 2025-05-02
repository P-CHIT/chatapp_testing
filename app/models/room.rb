class Room < ApplicationRecord
  has_many :messages
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users

  attr_accessor :user_ids

  after_create :assign_users

  private

  def assign_users
    return unless user_ids.present?

    user_ids.reject(&:blank?).each do |uid|
      RoomUser.create(room_id: id, user_id: uid)
    end
  end
end
