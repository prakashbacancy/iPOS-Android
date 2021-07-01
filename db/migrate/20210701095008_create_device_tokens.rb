class CreateDeviceTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :device_tokens do |t|
    	t.string "auth_token"
    	t.integer "user_id"
    	t.integer "location_id"
      t.timestamps
    end
  end
end
