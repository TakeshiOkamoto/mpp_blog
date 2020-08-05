class BlogImage < ApplicationRecord

  # 添付ファイル
  has_one_attached  :attachment

 validates :description, presence: true  
 
  # 検索対象のカラム ※デフォルトは全て
  def self.ransackable_attributes(auth_object = nil)
    %w[description]
  end     
end
