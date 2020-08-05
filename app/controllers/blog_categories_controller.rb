class BlogCategoriesController < ApplicationController
  before_action :set_blog_category, only: [:show, :edit, :update, :destroy]

  # GET /blog_categories
  def index
    @blog_categories = BlogCategory.all.order(sort: "ASC")
  end

  # GET /blog_categories/1
  def show
  end

  # GET /blog_categories/new
  def new
    @blog_category = BlogCategory.new
  end

  # GET /blog_categories/1/edit
  def edit
  end

  # POST /blog_categories
  def create
    @blog_category = BlogCategory.new(blog_category_params)
    
    # 全角対応の空白除去
    @blog_category.name = common_trim(@blog_category.name)  
    @blog_category.description =  common_trim(@blog_category.description)  
    
    if @blog_category.save
      redirect_to @blog_category, notice: '登録しました。'
    else
      render :new
    end
  end

  # PATCH/PUT /blog_categories/1
  def update
  
    @blog_category = BlogCategory.where(id: params[:id])

    # 全角対応の空白除去
    @blog_category[0].name = common_trim(params[:blog_category][:name])
    @blog_category[0].description = common_trim(params[:blog_category][:description])
    
    @blog_category[0].sort = params[:blog_category][:sort];
    
    @blog_category = @blog_category[0]
    
    # 検証
    if(!@blog_category.valid?) 
      render :edit
      return
    end 
          
    if @blog_category.save
      redirect_to @blog_category, notice: '更新しました。'
    else
      render :edit
    end
  end

  # DELETE /blog_categories/1
  def destroy
    @blog_category.destroy!
    redirect_to blog_categories_path, alert: '削除しました。' 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_category
      @blog_category = BlogCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_category_params
      params.require(:blog_category).permit(:name, :description, :sort)
    end
end
