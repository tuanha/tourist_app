class CreateAssignDevices < ActiveRecord::Migration
  def change
    create_table :assign_devices do |t|
      t.integer :device_id
      t.integer :traveller_id
      t.integer :tourguide_id
      t.timestamps null: false
    end
  end
end
