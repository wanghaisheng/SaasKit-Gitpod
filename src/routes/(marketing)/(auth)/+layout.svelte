<script lang="ts">
  import { onMount } from 'svelte';

  onMount(() => {
    console.log('Current origin:', window.location.origin);
  });
</script>

<div class="mx-auto flex max-w-screen-lg flex-col items-center">
	<div>
		<slot />
	</div>
</div>
