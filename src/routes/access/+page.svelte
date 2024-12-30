<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input';
	import { Label } from '$lib/components/ui/label';
	import { onMount } from 'svelte';
	import { supabase } from '$lib/supabaseClient';
	import { page } from '$app/stores';

	let inviteCode: string = '';
	let groupName: string | null = null;
	let organizerName: string | null = null;
	let groupId: string | null = null;

	onMount(async () => {
		const urlParams = new URLSearchParams(window.location.search);
		const code = urlParams.get('code');
		if (code) {
			inviteCode = code;

			const { data: groupData, error: groupError } = await supabase
				.from('groups')
				.select('name, owner_id')
				.eq('invite_code', code)
				.single();

			if (groupError) {
				console.error('Error fetching group:', groupError);
				return;
			}

			if (groupData) {
				groupName = groupData.name;
				groupId = groupData.id;

				const { data: userData, error: userError } = await supabase
					.from('users')
					.select('username')
					.eq('id', groupData.owner_id)
					.single();

				if (userError) {
					console.error('Error fetching user:', userError);
					return;
				}

				if (userData) {
					organizerName = userData.username;
				}
			}
		}
	});

	async function joinGroup() {
		if (!groupId) return;
		// Implement join group logic here
		console.log('Joining group with invite code:', inviteCode);
		console.log('Group ID:', groupId);
	}
</script>

<div class="container mx-auto p-4">
	<h1 class="mb-4 text-3xl font-bold">Join a Group</h1>
	{#if groupName && organizerName}
		<p class="mb-4">
			You've been invited to join {groupName} by {organizerName}. Join now!
		</p>
	{/if}
	<form class="space-y-4" on:submit|preventDefault={joinGroup}>
		<div>
			<Label for="inviteCode">Invite Code</Label>
			<Input type="text" id="inviteCode" bind:value={inviteCode} />
		</div>
		<Button type="submit">Join Group</Button>
	</form>
</div>
