class CreateBlogImages < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_images do |t|
      t.string :description, null: false

      t.timestamps
    end
    
    add_index :blog_images, :description        
  end
end
