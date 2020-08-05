class Api::BlogPaginationController < ApplicationController

  def index

    # [ページネーション]現在のページ(番号)
    page = params[:page] || 1
    if nil == (page =~ /\A[0-9]+\z/) # 数値以外は1とする
      page = 1;
    end

    # [ページネーション]データの表示件数
    per = params[:per] || 5

    # データの取得
    # LEFT JOIN --- > blog_articles.blog_category_id = blog_categories.id
    if params[:category_id] === "-1"
      # トップページ用
      blog_articles = BlogArticle.left_joins(:blog_category).order(created_at: "DESC").page(page).per(per)
      record_count_all = BlogArticle.count(:id)           
    else
      # カテゴリページ用
      blog_articles = BlogArticle.left_joins(:blog_category).where(blog_category_id: params[:category_id]).order(created_at: "DESC").page(page).per(per)
      record_count_all = BlogArticle.where(blog_category_id: params[:category_id]).count(:id)
    end      

    # JSON    
    response = {
        # 記事ID、タイトル、解説、登録日時、カテゴリID、カテゴリ名
        articles: blog_articles.select(:id, :title, :description, 
                                       'blog_articles.created_at as created_at',
                                       'blog_categories.id as category_id',
                                       'blog_categories.name as category_name'
                                        ),
        # [ページネーション]現在のページ(番号)                               
        page: page,  
        # [ページネーション]データの表示件数                               
        per: per,            
        # [ページネーション]全ページ数                           
        total_pages: blog_articles.total_pages,
        # レコード件数                             
        record_count: blog_articles.count(:id),           
        # レコード件数(全て)                             
        record_count_all: record_count_all          
      }
        
    render json: response
  end  
  
end
