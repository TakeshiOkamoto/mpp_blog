<template>
<div>
  <template v-if="items.length != 0">
    <p>Vue Routerのモードは「hash」です。ブラウザのURLの変化をご確認ください。</p>

    <div v-for="(item, index) in items">     
      <div v-bind:key="item.id" class="card" style="padding:18px;"> 
        <div>   
          <router-link v-bind:to="{name:'Article',params:{id: item.id}}">{{item.title}}</router-link>
          <div>
            {{formatConversion(item.created_at)}} 
            &nbsp;
            <router-link v-bind:to="{name:'Category',params:{id: item.category_id, page: 1}}" class="badge badge-custom">{{item.category_name}}</router-link>
          </div>
        </div>            
        {{item.description}}
      </div>
    </div>    
    
    <p></p>
    
    <nav aria-label="Page navigation">
      <ul class="pagination">
        <div v-for="i in total_pages">   
          <template v-if="i == page">
            <li class="page-item active"><router-link tag="a" v-bind:to="{name:'Home',params:{page: i}}" class="page-link">{{i}}</router-link></li>  
          </template>   
          <template v-else>   
            <li class="page-item"><router-link tag="a" v-bind:to="{name:'Home',params:{page: i}}" class="page-link">{{i}}</router-link></li>
          </template>  
        </div>
      </ul>
    </nav>
    <p>全{{record_count_all}}件中 {{getPaginationNow()}}件の記事が表示されています。</p>
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
      items: [],          // アイテム
      page: 1,            // [ページネーション]現在のページ(番号)
      per: 1,             // [ページネーション]データの表示件数  
      total_pages: 1,     // [ページネーション]全ページ数  
      record_count: 1,    // レコード件数    
      record_count_all: 1 // レコード件数(全て)               
    }
  },
  
  // ---------------------
  //  作成時
  // ---------------------    
  created() {
    if(this.$route.params.page){
      this.page = this.$route.params.page;
    }
    this.run_ajax();          
  },

  // ---------------------
  //  ウォッチャー
  // --------------------- 
  // $routeが変更されたときにpageを再設定する
  watch: {
    '$route'(to, from) {
      this.page = to.params.page;
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
      fetch("/api/blog_pagination?category_id=-1&page=" + this.page)
        .then(res => res.json()) 
        .then(
          (result) => {      
            
            // アイテム            
            this.items = result["articles"];      
            this.page = result["page"];  
            this.per = result["per"];              
            this.total_pages = result["total_pages"];             
            this.record_count = result["record_count"];
            this.record_count_all = result["record_count_all"];   
            
            if (this.items){
              document.title = "Rails + Vue.jsで作るSPAのブログシステム ";    
              document.querySelector('meta[name="keywords"]').setAttribute('content',"spa,vue");    
              document.querySelector('meta[name="description"]').setAttribute('content',"フルSPAのブログシステムです。(学習用)");       
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
.badge-custom {
  color: #fff;
  background-color: #6c757d;
}

.badge-custom:hover, 
.badge-custom:focus {
  color: #fff;
  background-color: #007bff;
  cursor: pointer;
}

.badge-custom:focus{
  outline: 0;
  box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.5);
  cursor: pointer;
}
.card:hover {
  color: #212529;
  background-color: rgba(0, 0, 0, 0.075);
}
</style>
