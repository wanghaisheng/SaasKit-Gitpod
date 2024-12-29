<script lang="ts">
	import { Button } from '$lib/components/ui/button';
</script>

<div class="container mx-auto p-4">
	<h1 class="text-3xl font-bold mb-4">Schedule Tee Time</h1>
	<form class="space-y-4">
		<div>
			<label
				for="date"
				class="block text-sm font-medium leading-none peer-disabled:cursor-not-allowed"
			>
				Date
			</label>
			<input
				type="date"
				id="date"
				class="w-full rounded-md border shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
			/>
		</div>
		<div>
			<label
				for="time"
				class="block text-sm font-medium leading-none peer-disabled:cursor-not-allowed"
			>
				Time
			</label>
			<input
				type="time"
				id="time"
				class="w-full rounded-md border shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
			/>
		</div>
		<div>
			<label
				for="maxPlayers"
				class="block text-sm font-medium leading-none peer-disabled:cursor-not-allowed"
			>
				Max Players
			</label>
			<input
				type="number"
				id="maxPlayers"
				class="w-full rounded-md border shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
			/>
		</div>
		<div>
			<label
				for="course"
				class="block text-sm font-medium leading-none peer-disabled:cursor-not-allowed"
			>
				Course
			</label>
			<select
				id="course"
				class="w-full rounded-md border shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
			>
				<option value="">Select a course</option>
				<!-- Course options will be loaded here -->
			</select>
		</div>
		<div>
			<label
				for="notes"
				class="block text-sm font-medium leading-none peer-disabled:cursor-not-allowed"
			>
				Notes
			</label>
			<textarea
				id="notes"
				class="w-full rounded-md border shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
			></textarea>
		</div>
		<Button type="submit">Schedule Tee Time</Button>
	</form>
</div>
