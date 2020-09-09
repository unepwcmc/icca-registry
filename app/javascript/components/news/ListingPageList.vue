<template>
  <div 
    class="cards--articles"
  >
    <div
      v-show="hasResults" 
      sm-trigger-element="test"
    >
      <div class="cards__cards">
        <article-card-news
          v-for="result, index in results.results"
          :key="result.key"
          :date="result.date"
          :image="result.image"
          :summary="result.summary"
          :title="result.title"
          :url="result.url"
        />
      </div>
      <pagination-infinity-scroll 
        v-if="smTriggerElement" 
        :smTriggerElement="smTriggerElement"
        :total="results.total"
        :total-pages="results.totalPages"
        v-on:request-more="requestMore"
      />
    </div>

    <p 
      v-show="!hasResults"
      v-html="textNoResults"
      class="search__results-none"
    />
  </div>
</template>

<script>
import ArticleCardNews from './ArticleCardNews.vue'
import PaginationInfinityScroll from '../pagination/PaginationInfinityScroll.vue'

export default {
  name: 'listing-page-list',

  components: { 
    ArticleCardNews,
    PaginationInfinityScroll
  },
  
  props: {
    results: {
      type: Object // { title: String, total: Number, results: [{ date: String, image: String, summary: String, title: String, url: String }
    },
    smTriggerElement: {
      required: true,
      type: String
    },
    textNoResults: {
      required: true,
      type: String
    }
  },

  computed: {
    hasResults () {
      return this.results.total > 0
    }
  },

  methods: {
    requestMore (paginationParams) {
      this.$emit('request-more', paginationParams)
    }
  }
}
</script>