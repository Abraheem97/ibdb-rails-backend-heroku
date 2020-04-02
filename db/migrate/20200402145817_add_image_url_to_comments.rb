class AddImageUrlToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :image_url, :string
  end
end
