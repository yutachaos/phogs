class AddRemarksToFinds < ActiveRecord::Migration
  def change
    add_column :finds, :service_remark, :string
  end
end
