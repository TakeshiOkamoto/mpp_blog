// IE11でVue.jsを動作させる
import "babel-polyfill"

import Vue from 'vue'
import App from '../main.vue'
import router from '../router.js'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router: router,
    render: h => h(App)
  }).$mount()
  document.getElementById('root').appendChild(app.$el)
})
