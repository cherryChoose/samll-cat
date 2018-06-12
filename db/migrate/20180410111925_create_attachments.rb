class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :file
      t.string :content_type
      t.string :origin_file_name
      t.integer :file_size
      t.string :human_size
      t.references :attachmentable,polymorphic: true

      t.timestamps
    end
  end
end
