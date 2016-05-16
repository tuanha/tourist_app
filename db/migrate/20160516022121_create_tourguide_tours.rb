class CreateTourguideTours < ActiveRecord::Migration
  def change
    create_table :tourguide_tours do |t|
      t.integer :tourguide_id
      t.integer :tour_id
      t.timestamps null: false
    end
  end
end
