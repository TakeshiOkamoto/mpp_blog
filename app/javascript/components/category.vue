<template>
<div>
  <p></p>
  
  <!-- 初期時にitem[0].category_nameがnullになるので回避 -->
  <template v-if="items.length != 0">  
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><router-link to="/">ホーム</router-link></li>
        <li class="breadcrumb-item active">{{items[0].category_name}}</li>
      </ol>
    </nav>
    
    <p></p>
    
    <div v-for="(item, index) in items">     
      <div v-bind:key="item.id" class="card" style="padding:18px;"> 
        <div>
          <router-link v-bind:to="{name:'Article',params:{id: item.id}}">{{item.title}}</router-link>
          <div>
          {{formatConversion(item.created_at)}}          
          </div>
        </div>
      </div>
    </div>
    
    <p></p>
    
    <nav aria-label="Page navigation">
      <ul class="pagination">
        <div v-for="i in total_pages">   
          <template v-if="i == page">
            <li class="page-item active"><router-link tag="a" v-bind:to="{name:'Category',params:{id: id ,page: i}}" class="page-link">{{i}}</router-link></li>  
          </template>   
          <template v-else>   
            <li class="page-item"><router-link tag="a" v-bind:to="{name:'Category',params:{id: id ,page: i}}" class="page-link">{{i}}</router-link></li>
          </template>  
        </div>
      </ul>
    </nav>
    <p>全{{record_count_all}}件中 {{getPaginationNow()}}件の記事が表示されています。</p>
      
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><router-link to="/">ホーム</router-link></li>
        <li class="breadcrumb-item active">{{items[0].category_name}}</li>
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
      items: [],          // アイテム
      id: 0,              // ID
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
    if(this.$route.params.id && this.$route.params.page){    
      this.id = this.$route.params.id;
      this.page = this.$route.params.page;
      this.run_ajax();
    }
  },
  
  // ---------------------
  //  ウォッチャー
  // --------------------- 
  // $routeが変更されたときにid/pageを再設定する
  watch: {
    '$route'(to, from) {  
      if(to.params.id && to.params.page){      
        this.id = to.params.id;
        this.page = to.params.page;
        this.run_ajax();
      }
     }
  },  
  
  // ---------------------
  //  メソッド
  // ---------------------   
  mixins: [Mixin],   
  methods: {

    // JSONデータの取得
    run_ajax: function() {  // 学習用なのでper=1000にしてるので注意
      fetch("/api/blog_pagination?&category_id=" + this.id + "&page=" + this.page)
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
            
            // 次は動的変更なのでSEO的には評価されないかも？
            if (this.items.length != 0 && this.items[0].category_name != null){
              document.title = this.items[0].category_name;    
              document.querySelector('meta[name="keywords"]').setAttribute('content', this.items[0].category_name);    
              document.querySelector('meta[name="description"]').setAttribute('content', this.items[0].category_name + "の記事一覧です。");                     
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
.card:hover {
  color: #212529;
  background-color: rgba(0, 0, 0, 0.075);
}
</style>
