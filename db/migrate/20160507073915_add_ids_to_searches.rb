class AddIdsToSearches < ActiveRecord::Migration
  def change
    add_column :searches , :service_remark, :string
  end
end
