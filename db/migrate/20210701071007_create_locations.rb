class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
    	t.string "business_name"
			t.string "phone_number"
			t.string "customer_contact_email"
			t.string "business_website"
			t.integer "user_id"
			t.boolean "enable_tax", default: false
			t.string "locale"
			t.string "currency"
			t.string "time_zone", default: "Eastern Time (US & Canada)"
			t.string "subdomain"
			t.string "report_start_time", default: "12:00 AM" 
			t.string "report_end_time", default: "11:59 PM"
			t.text "terms_and_conditions"
			t.boolean "service_charge_enable", default: true
			t.float "latitude", default: 0.0
			t.float "longitude", default: 0.0
      t.timestamps
    end
  end
end
