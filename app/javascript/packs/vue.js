// Vue
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import CarouselFlickity from '../components/carousel/CarouselFlickity.vue';

import ArticleCardNews from '../components/news/ArticleCardNews.vue';
import ListingPage from '../components/news/ListingPage.vue';

Vue.use(TurbolinksAdapter)

export const eventHub = new Vue();

document.addEventListener('turbolinks:load', () => {
    if(document.getElementById('v-app')) {
        Vue.prototype.$eventHub = new Vue()
        const app = new Vue({
            el: '#v-app',
            components: {
                CarouselFlickity,
                ArticleCardNews,
                ListingPage
            }
        })
    }
})