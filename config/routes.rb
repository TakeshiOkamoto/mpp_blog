Rails.application.routes.draw do

  # [API]記事の取得
  get '/api/blog_article', to: 'api/blog_article#index'
  # [API]ページネーション(トップ、カテゴリ用)
  get '/api/blog_pagination', to: 'api/blog_pagination#index'
  
  # デフォルトの記述
  #namespace :api do
  #  get 'blog_pagination/index'
  #end
  #namespace :api do
  #  get 'blog_article/index'
  #end  
  
  resources :blog_images
  resources :blog_articles
  resources :blog_categories
  
  root to: "blog_main#index"
    
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
