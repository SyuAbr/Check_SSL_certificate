class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :role, null: false, default: 'Сотрудник'
      t.string :api_token

      t.timestamps
    end

    add_index :users, :api_token, unique: true
  end
end
