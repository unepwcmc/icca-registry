<template>
  <flickity 
    :options="flickityOptions"
    ref="flickity"
    v-images-loaded="imgsLoaded"
  >
    <slot />
  </flickity>
</template>

<script>
import Flickity from "vue-flickity";
import imagesLoaded from 'vue-images-loaded';

export default {
  name: "CarouselFlickity",
  components: { Flickity },
  directives: { imagesLoaded },
  data() {
    return {
      flickityOptions: {
        initialIndex: 0,
        prevNextButtons: true,
        pageDots: true,
        lazyLoad: true,
        wrapAround: true,
        imagesLoaded: true
      }
    };
  },
  methods: {
    next() {
      this.$refs.flickity.next();
    },

    previous() {
      this.$refs.flickity.previous();
    },
    imgsLoaded() {
      let flickityInstance = this.$refs.flickity;
      flickityInstance.rerender();
    }
  }
};
</script>