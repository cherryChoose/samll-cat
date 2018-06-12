class AddAvatarsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :avatars, :string
  end
end
