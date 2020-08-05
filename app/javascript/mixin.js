// 日時操作
import {format} from 'date-fns'
import ja from 'date-fns/locale/ja'

export default {
  
  // ---------------------
  //  メソッド
  // ---------------------    
  methods: {
    
    // ---------------------      
    //  日付操作 
    // ---------------------      
    formatConversion: function(created_at) {
      return format(new Date(Date.parse(created_at)), 'yyyy年MM月dd日(iiiii) HH:mm:ss', {locale: ja});
    },
    
    // ---------------------      
    //  ページネーション 
    // --------------------- 
    // ? - ? の部分を生成する
    getPaginationNow: function() {
      
      if (!this.page || this.page == 1){
        if (this.per > this.record_count_all){
          return "1 - " + this.record_count_all;
        }else{
          return "1 - " + this.per;
        }
      }else{
        let st = (this.page - 1) * this.per + 1;
        let en = (st + (this.record_count -1));
        return  st + " - " + en;         
      } 
    }        
  }  
}