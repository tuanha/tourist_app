class AddTourIdToTourguide < ActiveRecord::Migration
  def change
    add_column :tourguides, :tour_id, :integer
  end
end
