<script lang="ts">
	import { getLocalTimeZone, today } from "@internationalized/date";
	import { Calendar } from "$lib/components/ui/calendar/index.js";

	let value = today(getLocalTimeZone());
</script>

<Calendar bind:value class="rounded-md border shadow" />
