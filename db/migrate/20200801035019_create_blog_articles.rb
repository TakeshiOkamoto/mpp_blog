class CreateBlogArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_articles do |t|
      t.integer :blog_category_id, null: false
      t.string :title, null: false
      t.string :keywords, null: false
      t.string :description, null: false
      t.text :body, null: false

      t.timestamps
    end
    
    add_index :blog_articles, :blog_category_id    
    add_index :blog_articles, :title, :unique  => true    

  end
end
