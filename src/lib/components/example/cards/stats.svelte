<script lang="ts">
	import * as Card from "$lib/components/ui/card/index.js";
	import { Revenue, Subscription } from "$lib/components/docs/charts/index.js";
</script>

<div class="grid gap-4 sm:grid-cols-2 xl:grid-cols-2">
	<Card.Root>
		<Card.Header class="flex flex-row items-center justify-between space-y-0 pb-2">
			<Card.Title class="text-sm font-normal">Total Revenue</Card.Title>
		</Card.Header>
		<Card.Content>
			<div class="text-2xl font-bold">$15,231.89</div>
			<p class="text-muted-foreground text-xs">+20.1% from last month</p>
			<div class="h-[80px]">
				<Revenue />
			</div>
		</Card.Content>
	</Card.Root>
	<Card.Root>
		<Card.Header class="flex flex-row items-center justify-between space-y-0 pb-2">
			<Card.Title class="text-sm font-normal">Subscriptions</Card.Title>
		</Card.Header>
		<Card.Content>
			<div class="text-2xl font-bold">+2350</div>
			<p class="text-muted-foreground text-xs">+180.1% from last month</p>
			<div class="mt-4 h-[80px]">
				<Subscription />
			</div>
		</Card.Content>
	</Card.Root>
</div>
