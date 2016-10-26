class AddImageUrlToSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :image_url, :string
  end
end
