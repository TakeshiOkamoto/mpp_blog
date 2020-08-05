class BlogImagesController < ApplicationController
  before_action :set_blog_image, only: [:show, :edit, :update, :destroy]

  # GET /blog_images
  def index
    @q = BlogImage.all.order(created_at: "DESC")
    
    # 空白除去 ※全角空白を半角空白に変換含む
    if params[:q].present?
      params[:q][:description_cont]= common_trim(params[:q][:description_cont])
    end  
    
    @q = @q.ransack(params[:q])  
    @blog_images = @q.result(distinct: true).page(params[:page]).per(25)     
  end

  # GET /blog_images/1
  def show
  end

  # GET /blog_images/new
  def new
    @blog_image = BlogImage.new
  end

  # GET /blog_images/1/edit
  def edit
  end

  # POST /blog_images
  def create
    @blog_image = BlogImage.new(blog_image_params)

    # 全角対応の空白除去
    @blog_image.description =  common_trim(@blog_image.description)
    
    # 添付ファイル  
    @blog_image.attachment = params[:blog_image][:attachment]  
    
    if @blog_image.save
      redirect_to @blog_image, notice: '登録しました。'
    else
     render :new 
    end
  end

  # PATCH/PUT /blog_images/1
  def update
  
    @blog_image = BlogImage.where(id: params[:id])
    
    # 全角対応の空白除去
    @blog_image[0].description = common_trim(params[:blog_image][:description])  
    
    # 添付ファイル  
    if params[:blog_image][:attachment].present?      
      @blog_image[0].attachment = params[:blog_image][:attachment]        
    end
    
    @blog_image = @blog_image[0]
    
    # 検証
    if(!@blog_image.valid?) 
      render :edit
      return
    end 
          
    if @blog_image.save
      redirect_to @blog_image, notice: '更新しました。'
    else
      render :edit
    end
  end

  # DELETE /blog_images/1
  def destroy
    @blog_image.destroy!
    redirect_to blog_images_path, alert: '削除しました。'    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_image
      @blog_image = BlogImage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_image_params
      params.require(:blog_image).permit(:description, :attachment)
    end
end
