class CreateBlogCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_categories do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :sort, null: false

      t.timestamps
    end
    
    add_index :blog_categories, :name, :unique  => true         
  end
end
