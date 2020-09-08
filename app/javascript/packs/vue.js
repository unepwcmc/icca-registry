// Vue
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import CarouselFlickity from '../components/carousel/CarouselFlickity.vue';

import ArticleCardNews from '../components/news/ArticleCardNews.vue';
// import Filters from '../filters/Filters.vue';

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
    if(document.getElementById('v-app')) {
        new Vue({
            el: '#v-app',
            components: {
                CarouselFlickity,
                ArticleCardNews,
                // Filters
            }
        })
    }
})