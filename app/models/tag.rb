class Tag < ApplicationRecord
  has_and_belongs_to_many :websites
  has_many :chats, dependent: :destroy

  validates :name, presence: true, uniqueness: { message: 'Тег с таким названием уже существует.' }
  validates :bot_token, presence: true
end
