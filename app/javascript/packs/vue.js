// Vue
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Flickity from 'vue-flickity'


Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
    if(document.getElementById('v-app')) {
        new Vue({
            el: '#v-app',
            components: {
                Flickity
            },
            data() {
                return {
                    flickityOptions: {
                        initialIndex: 0,
                        prevNextButtons: true,
                        pageDots: true,
                        wrapAround: true
                    }
                }
            },
            methods: {
                next() {
                    this.$refs.flickity.next();
                },
                
                previous() {
                    this.$refs.flickity.previous();
                }
            }
        })
    }
})