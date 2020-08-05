class BlogArticle < ApplicationRecord

  # 親の指定(単数形で指定する)
  # ※required: falseで検証を回避する
  belongs_to :blog_category, required: false

  validates :blog_category_id, presence: true  
  validates :title, presence: true, uniqueness: true, length: { maximum: 120 }
  validates :keywords, presence: true  
  validates :description, presence: true
  validates :body, presence: true    
  
  # 検索対象のカラム ※デフォルトは全て
  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end    
end
