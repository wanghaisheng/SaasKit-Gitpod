<script lang="ts">
	import FontItalic from "svelte-radix/FontItalic.svelte";
	import { Toggle } from "$lib/components/ui/toggle/index.js";
</script>

<Toggle size="lg" aria-label="Toggle italic">
	<FontItalic class="h-4 w-4" />
</Toggle>
