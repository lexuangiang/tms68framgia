class AddImageUrlToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :image_url, :string
  end
end
