<script lang="ts">
	import { onMount } from 'svelte';
	import { supabase } from '$lib/supabaseClient';
	import * as Card from '$lib/components/ui/card';

	interface TeeTime {
		id: number;
		date: string;
		time: string;
		course: string;
		maxPlayers: number;
		notes: string;
	}

	let teeTimes: TeeTime[] = [];

	onMount(async () => {
		// Fetch tee times from database
		const { data: teeTimesData, error: teeTimesError } = await supabase
			.from('tee_times')
			.select('*');

		if (teeTimesError) {
			console.error('Error fetching tee times:', teeTimesError);
			return;
		}

		teeTimes = teeTimesData || [];
	});
</script>

<div class="container mx-auto p-4">
	<h1 class="mb-4 text-3xl font-bold">Manage Tee Times</h1>
	<div class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
		{#each teeTimes as teeTime}
			<a href="/(app)/tee-times/{teeTime.id}">
				<Card.Root
					class="mb-2 rounded-md border p-2 transition-colors hover:bg-gray-100"
				>
					<p>Date: {teeTime.date}</p>
					<p>Time: {teeTime.time}</p>
					<p>Course: {teeTime.course}</p>
				</Card.Root>
			</a>
		{/each}
	</div>
</div>
