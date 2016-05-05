class CreateTravellerTours < ActiveRecord::Migration
  def change
    create_table :traveller_tours do |t|
      t.integer :traveller_id
      t.integer :tour_id
      t.string :status, default: 'pending'
      t.timestamps null: false
    end
  end
end
