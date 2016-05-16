class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string   :name
      t.string   :lat
      t.string   :lng
      t.string   :code
      t.string   :reg_id
      t.integer  :tour_id
      t.timestamps null: false
    end
  end
end
