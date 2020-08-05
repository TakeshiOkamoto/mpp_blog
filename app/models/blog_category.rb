class BlogCategory < ApplicationRecord

  # 子の指定(複数形で指定する)
  has_many :blog_articles

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :description, presence: true
  validates :sort, presence: true    
end
