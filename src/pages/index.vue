<template>
  <Tutorial />
</template>

<script lang="ts">
import { Component, Vue } from 'nuxt-property-decorator';
import Tutorial from "../components/Tutorial.vue"

@Component({
  components: {
    Tutorial,
  }
})
export default class Index extends Vue {}
</script>
