class BlogArticlesController < ApplicationController
  
  # アクション前
  before_action :set_blog_article, only: [:show, :edit, :update, :destroy]  
  before_action :blog_get_category_combobox 
  
  # ヘルパーメソッド
  helper_method :blog_get_category_from_id
  
  # GET /blog_articles
  def index
    if @blog_category_list.length == 0
      redirect_to blog_categories_path, alert: 'カテゴリを登録して下さい。'
      return
    end
    
    @q = BlogArticle.all.order(created_at: "DESC")
    
    # 空白除去 ※全角空白を半角空白に変換含む
    if params[:q].present?
      params[:q][:title_cont]= common_trim(params[:q][:title_cont])
    end  
    
    @q = @q.ransack(params[:q])  
    @blog_articles = @q.result(distinct: true).page(params[:page]).per(25)  
  end

  # GET /blog_articles/1
  def show
  end

  # GET /blog_articles/new
  def new
    @blog_article = BlogArticle.new
  end

  # GET /blog_articles/1/edit
  def edit
  end

  # POST /blog_articles  
  def create
    @blog_article = BlogArticle.new(blog_article_params)

    # 全角対応の空白除去
    @blog_article.title = common_trim(@blog_article.title)  
    @blog_article.keywords =  common_trim(@blog_article.keywords)  
    @blog_article.description =  common_trim(@blog_article.description)  
    
    # 前後の半角空白除去
    @blog_article.body =  @blog_article.body.strip    
    
    if @blog_article.save
      redirect_to @blog_article, notice: '登録しました。'
    else
     render :new 
    end
  end

  # PATCH/PUT /blog_articles/1
  def update
  
    @blog_article = BlogArticle.where(id: params[:id])    
    @blog_article[0].blog_category_id = params[:blog_article][:blog_category_id]
    
    # 全角対応の空白除去
    @blog_article[0].title = common_trim(params[:blog_article][:title])
    @blog_article[0].keywords = common_trim(params[:blog_article][:keywords])
    @blog_article[0].description = common_trim(params[:blog_article][:description])  

    # 前後の半角空白除去          
    @blog_article[0].body = params[:blog_article][:body].strip
    
    @blog_article = @blog_article[0]
    
    # 検証
    if(!@blog_article.valid?) 
      render :edit
      return
    end 
          
    if @blog_article.save
      redirect_to @blog_article, notice: '更新しました。'
    else
      render :edit
    end
  end

  # DELETE /blog_articles/1
  def destroy
    @blog_article.destroy!
    redirect_to blog_articles_path, alert: '削除しました。'     
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_article
      @blog_article = BlogArticle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_article_params
      params.require(:blog_article).permit(:blog_category_id, :title, :keywords, :description, :body)
    end
end
