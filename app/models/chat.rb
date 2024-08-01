class Chat < ApplicationRecord
  belongs_to :tag

  validates :chat_id, presence: true
  validates :chat_id, uniqueness: { scope: :tag_id }
end
