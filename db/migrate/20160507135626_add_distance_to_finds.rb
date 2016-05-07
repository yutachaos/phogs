class AddDistanceToFinds < ActiveRecord::Migration
  def change
    add_column :finds, :distance, :integer
  end
end
