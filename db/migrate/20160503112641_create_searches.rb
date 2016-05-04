class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string   :name
      t.string   :point
      t.string   :middle_area
      t.string   :large_area
      t.string   :food_code
      t.timestamps
    end
  end
end
