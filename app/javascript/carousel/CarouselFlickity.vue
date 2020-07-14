<template>
  <flickity 
    :options="flickityOptions"
    ref="flickity"
  >
    <slot />
  </flickity>
</template>

<script>
import Flickity from "vue-flickity";

export default {
  name: "CarouselFlickity",
  components: { Flickity },
  data() {
    return {
      flickityOptions: {
        initialIndex: 0,
        prevNextButtons: true,
        pageDots: true,
        wrapAround: true
      }
    };
  },
  methods: {
    next() {
      this.$refs.flickity.next();
    },

    previous() {
      this.$refs.flickity.previous();
    }
  }
};
</script>