<script lang="ts">
	import CardWithForm from '$lib/components/example/card-with-form.svelte';
	import ScorecardUpload from '$lib/components/scorecard-upload.svelte';
	import { onMount } from 'svelte';
	import { supabase } from '$lib/supabaseClient';
	import { page } from '$app/stores';

	interface TeeTime {
		id: number;
		date: string;
		time: string;
		course: string;
		maxPlayers: number;
		notes: string;
	}

	let teeTime: TeeTime | null = null;
	let id: string | null = null;

	onMount(async () => {
		id = $page.params.id;
		if (id) {
			// Fetch tee time from database
			const { data: teeTimeData, error: teeTimeError } = await supabase
				.from('tee_times')
				.select('*')
				.eq('id', id)
				.single();

			if (teeTimeError) {
				console.error('Error fetching tee time:', teeTimeError);
				return;
			}

			teeTime = teeTimeData;
		}
	});
</script>

<div class="container mx-auto p-4">
	{#if teeTime}
		<h1 class="mb-4 text-3xl font-bold">Tee Time Details</h1>
		<CardWithForm>
			<div class="space-y-4">
				<p>Date: {teeTime.date}</p>
				<p>Time: {teeTime.time}</p>
				<p>Course: {teeTime.course}</p>
				<p>Max Players: {teeTime.maxPlayers}</p>
				<p>Notes: {teeTime.notes}</p>
				<ScorecardUpload />
			</div>
		</CardWithForm>
	{:else}
		<p>Tee time not found.</p>
	{/if}
</div>
