class AddImageUrlToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :image_url, :string
  end
end
