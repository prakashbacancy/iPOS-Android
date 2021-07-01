class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :is_active
      t.integer :location_id

      t.timestamps
    end
  end
end
