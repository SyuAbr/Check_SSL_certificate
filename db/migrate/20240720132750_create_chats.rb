class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.string :chat_id
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :chats, [:chat_id, :tag_id], unique: true
  end
end
