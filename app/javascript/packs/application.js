/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Vue
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Flickity from 'vue-flickity'

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require('jquery')

require("../modules/accordion")
require("../modules/block_page")
require("../modules/dropdown")
require("../modules/gallery")
require("../modules/interest_form")
require("../modules/map")
require("../modules/toggle")
require("../modules/ui_state")
require("common")

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