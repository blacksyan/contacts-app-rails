class AddForeignKeyToContact < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :contacts, :users, column: :owner_id
  end
end
