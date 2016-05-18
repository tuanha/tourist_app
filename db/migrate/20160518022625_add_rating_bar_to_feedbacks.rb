class AddRatingBarToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :rating_bar, :string
  end
end
