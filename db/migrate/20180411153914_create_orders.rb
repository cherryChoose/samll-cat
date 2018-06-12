class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :uid
      t.string :name
      t.string :email
      t.string :pay_type
      t.string :address
      t.references :user
      t.timestamps
    end
  end

  add_column :line_items,:order_id,:integer
end
