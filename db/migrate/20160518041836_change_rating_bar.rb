class ChangeRatingBar < ActiveRecord::Migration
  def change
  	rename_column :feedbacks, :rating_bar, :rating
  end
end
