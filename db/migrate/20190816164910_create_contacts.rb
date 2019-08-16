class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :mobile
      t.string :work
      t.string :office
      t.jsonb :others, default: {}
      t.integer :owner_id, null: false

      t.timestamps
    end
  end
end
