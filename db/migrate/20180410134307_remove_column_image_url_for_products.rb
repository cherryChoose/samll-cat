class RemoveColumnImageUrlForProducts < ActiveRecord::Migration[5.0]
  def change
    remove_column :products,:image_url
    remove_column :products,:avatars
  end
end
