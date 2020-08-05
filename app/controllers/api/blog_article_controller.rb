class Api::BlogArticleController < ApplicationController

  def index
  
    # データの取得
    # LEFT JOIN --- > blog_articles.blog_category_id = blog_categories.id  
    blog_article = BlogArticle.left_joins(:blog_category).where(id: params[:id])    
    
    render json: blog_article.select(:id, :title, :keywords, :description, :body, 
                                       'blog_articles.created_at as created_at',
                                       'blog_categories.id as category_id',
                                       'blog_categories.name as category_name'
                                        )       
  end
  
end
