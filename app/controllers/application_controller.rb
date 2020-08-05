class ApplicationController < ActionController::Base

# -----------------------------
#  メソッド
# -----------------------------

  # 空白除去 ※全角空白を半角空白に変換含む
  def common_trim(str)
    str.gsub("　"," ").strip  
  end  
  
  # コンボボックス用 - カテゴリ
  def blog_get_category_combobox()
    category = BlogCategory.all.order(sort: "ASC")
    @blog_category_list = []
    category.each { |obj| 
      @blog_category_list.push([obj['name'],obj['id']])
    }
  end
    
# -----------------------------
#  ヘルパーメソッド
# -----------------------------
    
  # idからカテゴリ名を取得する 
  def blog_get_category_from_id(id)
     @blog_category_list.each_with_index do |obj,i|
       if(obj[1] == id)
         return obj[0]
       end  
     end
     return "";
  end 
      
end
