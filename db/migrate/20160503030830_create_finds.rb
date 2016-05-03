class CreateFinds < ActiveRecord::Migration
  def change
    create_table :finds do |t|
      t.string   :shop_id
      t.string   :name
      t.string   :url
      t.string   :image_url
      t.timestamps
    end
  end
end
