class AddDetaillssToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :lat, :float
    add_column :searches, :lon, :float
  end
end
