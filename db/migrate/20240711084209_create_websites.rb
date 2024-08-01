class CreateWebsites < ActiveRecord::Migration[7.1]
  def change
    create_table :websites do |t|
      t.string :address, null: false
      t.date :certificate_expiration, null: false
      t.integer :user_id, null: false
      t.string :tags, array: true, default: []

      t.timestamps
    end

    add_foreign_key :websites, :users, column: :user_id
    add_index :websites, :tags, using: 'gin'
  end
end
