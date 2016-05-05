class DeleteColumnSearches < ActiveRecord::Migration
  def change
    remove_column :searches, :point, :string
    remove_column :searches, :large_area, :string
    remove_column :searches, :middle_area, :string
    remove_column :searches, :food_code, :string
  end
end
