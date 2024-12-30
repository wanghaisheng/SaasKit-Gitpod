<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input';
	import { Label } from '$lib/components/ui/label';
	import { supabase } from '$lib/supabaseClient';
	import { onMount } from 'svelte';

	let userSubscription: any = null;
	let user: any = null;

	onMount(async () => {
		const {
			data: { user: supabaseUser },
			error,
		} = await supabase.auth.getUser();
		if (error) {
			console.error('Error fetching user:', error);
			return;
		}
		user = supabaseUser;

		if (user) {
			const { data: subscriptionData, error: subscriptionError } =
				await supabase
					.from('stripe_customers')
					.select('stripe_customer_id')
					.eq('user_id', user.id)
					.single();

			if (subscriptionError) {
				console.error('Error fetching subscription:', subscriptionError);
				return;
			}

			if (subscriptionData) {
				const { data: subscriptions, error: fetchSubscriptionError } =
					await supabase
						.from('stripe_subscriptions')
						.select('*')
						.eq('customer_id', subscriptionData.stripe_customer_id);

				if (fetchSubscriptionError) {
					console.error(
						'Error fetching subscription details:',
						fetchSubscriptionError,
					);
					return;
				}

				if (subscriptions && subscriptions.length > 0) {
					userSubscription = subscriptions[0];
				}
			}
		}
	});

	async function handleScorecardUpload(event: Event) {
		const fileInput = event.target as HTMLInputElement;
		if (fileInput.files && fileInput.files.length > 0) {
			const file = fileInput.files[0];
			console.log('Uploading file:', file);

			if (user && user.id) {
				const { data, error } = await supabase.storage
					.from('scorecards')
					.upload(`${user.id}/${file.name}`, file, {
						cacheControl: '3600',
						upsert: false,
					});

				if (error) {
					console.error('Error uploading file:', error);
				} else {
					console.log('File uploaded successfully:', data);
					// Handle successful upload
				}
			}
		}
	}
</script>

{#if userSubscription && (userSubscription.plan === 'premium' || userSubscription.plan === 'pro' || userSubscription.plan === 'enterprise')}
	<div class="space-y-4">
		<Label for="scorecard">Upload Scorecard</Label>
		<Input
			type="file"
			id="scorecard"
			accept="image/*"
			on:change={handleScorecardUpload}
		/>
		<p class="text-sm text-gray-500">
			Upload a picture of your scorecard after the round.
		</p>
	</div>
{:else}
	<p class="text-sm text-gray-500">
		Scorecard uploads are only available on Premium, Pro, and Enterprise plans.
	</p>
{/if}
