<template>
<div>
  <p></p>
  
  <!-- 初期時にはitem.category_idがnullになるので回避 -->
  <template v-if="item != null && item.category_id != null">
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><router-link to="/">ホーム</router-link></li>
        <li class="breadcrumb-item"><router-link v-bind:to="{name:'Category',params:{id: item.category_id, page: 1}}">{{item.category_name}}</router-link></li>      
        <li class="breadcrumb-item active">{{item.title}}</li>
      </ol>
    </nav>

    <span v-html="item.body"></span>    
    
    <p></p>
    
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><router-link to="/">ホーム</router-link></li>
        <li class="breadcrumb-item"><router-link v-bind:to="{name:'Category',params:{id: item.category_id, page: 1}}">{{item.category_name}}</router-link></li>      
        <li class="breadcrumb-item active">{{item.title}}</li>
      </ol>
    </nav>
  </template>
</div>  
</template>

<script>

// IEのfetch対策用
import "fetch-polyfill";

// ミックスイン
import Mixin from '../mixin.js'

export default {

  // ---------------------
  //  データ定義
  // ---------------------
  data: function () {
    return {
      item: {}, // アイテム
      id: 0     // ID
    }  
  },
  
  // ---------------------
  //  作成時
  // ---------------------    
  created() {
    this.id = this.$route.params.id
    this.run_ajax();
  },

  // ---------------------
  //  ウォッチャー
  // --------------------- 
  // $routeが変更されたときにidを再設定する
  watch: {
    '$route'(to, from) {
      this.id = to.params.id;
      this.run_ajax();
     }
  },
    
  // ---------------------
  //  メソッド
  // ---------------------   
  mixins: [Mixin],   
  methods: {
    
    // JSONデータの取得
    run_ajax: function() {
      
      fetch("/api/blog_article?id=" + this.id)
        .then(res => res.json()) 
        .then(
          (result) => {           
              
            // アイテム                          
            this.item = result[0];
            
            // 次は動的変更なのでSEO的には評価されないかも？
            if (this.item){
              document.title = this.item.title;    
              document.querySelector('meta[name="keywords"]').setAttribute('content',this.item.keywords);    
              document.querySelector('meta[name="description"]').setAttribute('content',this.item.description);       
            }
          },
          (error) => {
            alert(error.message);
          }
        )    
    }   
  },  
  
  // ---------------------
  //  算出プロパティ
  // ---------------------    
  computed: {  
    // none
  }  
}
</script>

<style scoped>
</style>
