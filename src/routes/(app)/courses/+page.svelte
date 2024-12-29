<script lang="ts">
	import CardWithForm from '$lib/components/example/card-with-form.svelte';
	import CardDemo from '$lib/components/example/card-demo.svelte';
	import { onMount } from 'svelte';
	import { supabase } from '$lib/supabaseClient';
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input';
	import { Label } from '$lib/components/ui/label';

	interface Course {
		id: number;
		name: string;
		address: string;
		coordinates: string;
	}

	let courses: Course[] = [];

	onMount(async () => {
		// Fetch courses from database
		const { data: coursesData, error: coursesError } = await supabase
			.from('courses')
			.select('*');

		if (coursesError) {
			console.error('Error fetching courses:', coursesError);
			return;
		}

		courses = coursesData || [];
	});
</script>

<div class="container mx-auto p-4">
	<h1 class="mb-4 text-3xl font-bold">Manage Courses</h1>
	<div class="grid grid-cols-2 gap-4">
		<div>
			<h2 class="mb-2 text-xl font-semibold">Add Course</h2>
			<CardWithForm>
				<form class="space-y-4">
					<div>
						<Label for="name">Name</Label>
						<Input type="text" id="name" />
					</div>
					<div>
						<Label for="address">Address</Label>
						<Input type="text" id="address" />
					</div>
					<div>
						<Label for="coordinates">Coordinates</Label>
						<Input type="text" id="coordinates" />
					</div>
					<Button type="submit">Add Course</Button>
				</form>
			</CardWithForm>
		</div>
		<div>
			<h2 class="mb-2 text-xl font-semibold">Courses</h2>
			{#each courses as course}
				<CardDemo>
					<p>Name: {course.name}</p>
					<p>Address: {course.address}</p>
					<p>Coordinates: {course.coordinates}</p>
				</CardDemo>
			{/each}
		</div>
	</div>
</div>
