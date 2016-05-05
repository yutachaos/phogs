class AddColumnSearches < ActiveRecord::Migration
  def change
    add_column :searches, :full_location, :string
  end
end
