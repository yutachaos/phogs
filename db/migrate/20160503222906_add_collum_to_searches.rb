class AddCollumToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :image_url, :string
  end
end
