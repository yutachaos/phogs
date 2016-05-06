class RemoveAuthorFromSearches < ActiveRecord::Migration
  def change
    remove_column :searches, :lat, :float
    remove_column :searches, :lon, :float
  end
end
