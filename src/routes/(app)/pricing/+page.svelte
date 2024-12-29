<script lang="ts">
	import PriceCore from '$lib/components/price/price-core.svelte';
	import PriceAmount from '$lib/components/price/price-amount.svelte';
	import PriceBadges from '$lib/components/price/price-badges.svelte';
	import PriceButton from '$lib/components/price/price-button.svelte';
	import { onMount } from 'svelte';
	import { supabase } from '$lib/supabaseClient';
	import type Stripe from 'stripe';

	let prices: Stripe.Price[] = [];

	onMount(async () => {
		// Fetch prices from database
		const { data: pricesData, error: pricesError } = await supabase
			.from('stripe_prices')
			.select('*');

		if (pricesError) {
			console.error('Error fetching prices:', pricesError);
			return;
		}

		prices = pricesData || [];
	});

	const pricingTiers = [
		{
			name: 'Free (Starter)',
			price: 0,
			priceId: 'price_1Nq71s2eZvKYlo2C09876543',
			groups: 1,
			players: 8,
			features: ['Basic scheduling', 'Email notifications'],
		},
		{
			name: 'Premium',
			price: 15,
			priceId: 'price_1Nq71s2eZvKYlo2C09876544',
			groups: 1,
			players: 24,
			features: [
				'Scheduling',
				'Email notifications',
				'Custom avatar profile pictures',
				'Upload scorecard images after round',
			],
		},
		{
			name: 'Pro',
			price: 30,
			priceId: 'price_1Nq71s2eZvKYlo2C09876545',
			groups: 5,
			players: 'Unlimited',
			features: [
				'Scheduling',
				'Email notifications',
				'Custom avatar profile pictures',
				'Upload scorecard images after round',
			],
		},
		{
			name: 'Enterprise',
			price: 50,
			priceId: 'price_1Nq71s2eZvKYlo2C09876546',
			groups: 5,
			players: 'Unlimited',
			features: [
				'Scheduling',
				'Email notifications',
				'Custom avatar profile pictures',
				'Upload scorecard images after round',
			],
		},
	];
</script>

<div class="container mx-auto p-4">
	<h1 class="mb-4 text-3xl font-bold">Pricing</h1>
	<div class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4">
		{#each pricingTiers as tier}
			<PriceCore
				price={{
					id: tier.priceId,
					unit_amount: tier.price * 100,
					currency: 'usd',
					type: 'recurring',
				}}
			>
				<div class="rounded-md border p-4">
					<h2 class="mb-2 text-xl font-semibold">{tier.name}</h2>
					<PriceAmount amount={tier.price} currency="USD" />
					<PriceBadges>
						<span class="text-sm">Groups: {tier.groups}</span>
						<span class="text-sm">Players: {tier.players}</span>
					</PriceBadges>
					<ul class="mt-2 list-disc pl-4">
						{#each tier.features as feature}
							<li class="text-sm">{feature}</li>
						{/each}
					</ul>
					<PriceButton priceId={tier.priceId}>Choose Plan</PriceButton>
				</div>
			</PriceCore>
		{/each}
	</div>
</div>
