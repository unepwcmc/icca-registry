// Vue
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import CarouselFlickity from '../components/carousel/CarouselFlickity.vue';

import ArticleCardNews from '../components/news/ArticleCardNews.vue';
import ListingPage from '../components/news/ListingPage.vue';

Vue.use(TurbolinksAdapter)

export const eventHub = new Vue();

// Have to set it up like this because Vue is only being used for certain views
document.addEventListener('turbolinks:load', () => {
  if (document.getElementById('v-carousel')) {

    new Vue({
      el: '#v-carousel',
      components: {
        CarouselFlickity
      }
    })
  }

  if (document.getElementById('v-articles')) {
    new Vue({
      el: '#v-articles',
      components: {
        ArticleCardNews
      }
    })
  }

  if (document.getElementById('v-listing')) {

    Vue.prototype.$eventHub = new Vue()

    new Vue({
      el: '#v-listing',
      components: {
        ListingPage
      }
    })
  }
})



