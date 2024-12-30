<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input';
	import { Label } from '$lib/components/ui/label';
	import * as Card from '$lib/components/ui/card';
	import { onMount } from 'svelte';
	import { supabase } from '$lib/supabaseClient';
	import { page } from '$app/stores';

	interface Group {
		id: number;
		name: string;
		owner_id: string;
		members: string[];
		invite_code: string;
	}

	let group: Group | null = null;
	let groupId: string | null = null;
	let newMemberEmail: string = '';
	let user: any = null;
	let newInviteCode: string = '';

	onMount(async () => {
		const {
			data: { user: supabaseUser },
		} = await supabase.auth.getUser();
		user = supabaseUser;

		groupId = $page.params.groupId;
		if (groupId) {
			// Fetch group from database
			const { data: groupData, error: groupError } = await supabase
				.from('groups')
				.select('*')
				.eq('id', groupId)
				.single();

			if (groupError) {
				console.error('Error fetching group:', groupError);
				return;
			}

			group = groupData;
			newInviteCode = group?.invite_code || '';
		}
	});

	async function addMember() {
		if (!group || !groupId) return;

		const { data: userData, error: userError } = await supabase
			.from('users')
			.select('id')
			.eq('email', newMemberEmail)
			.single();

		if (userError) {
			console.error('Error fetching user:', userError);
			return;
		}

		if (!userData) {
			console.error('User not found');
			return;
		}

		const newMembers = group.members
			? [...group.members, userData.id]
			: [userData.id];

		const { error: updateError } = await supabase
			.from('groups')
			.update({ members: newMembers })
			.eq('id', groupId);

		if (updateError) {
			console.error('Error adding member:', updateError);
			return;
		}

		group.members = newMembers;
		newMemberEmail = '';
	}

	async function removeMember(memberId: string) {
		if (!group || !groupId) return;

		const newMembers = group.members?.filter((id) => id !== memberId) || [];

		const { error: updateError } = await supabase
			.from('groups')
			.update({ members: newMembers })
			.eq('id', groupId);

		if (updateError) {
			console.error('Error removing member:', updateError);
			return;
		}

		group.members = newMembers;
	}

	async function transferOwnership(newOwnerId: string) {
		if (!group || !groupId) return;

		const { error: updateError } = await supabase
			.from('groups')
			.update({ owner_id: newOwnerId })
			.eq('id', groupId);

		if (updateError) {
			console.error('Error transferring ownership:', updateError);
			return;
		}

		group.owner_id = newOwnerId;
	}

	async function changeInviteCode() {
		if (!group || !groupId) return;

		const { error: updateError } = await supabase
			.from('groups')
			.update({ invite_code: newInviteCode })
			.eq('id', groupId);

		if (updateError) {
			console.error('Error changing invite code:', updateError);
			return;
		}

		group.invite_code = newInviteCode;
	}
</script>

<div class="container mx-auto p-4">
	{#if group}
		<h1 class="mb-4 text-3xl font-bold">Group Details</h1>
		<Card.Root class="mb-4 rounded-md border p-4">
			<h2 class="mb-2 text-xl font-semibold">{group.name}</h2>
			<p>Owner ID: {group.owner_id}</p>
			{#if group.owner_id === user?.id}
				<div class="mt-2">
					<h3 class="mb-2 text-lg font-semibold">Transfer Ownership</h3>
					<div class="flex space-x-2">
						<Input
							type="text"
							placeholder="Enter new owner ID"
							bind:value={newMemberEmail}
						/>
						<Button on:click={() => transferOwnership(newMemberEmail)}
							>Transfer</Button
						>
					</div>
				</div>
				<div class="mt-2">
					<h3 class="mb-2 text-lg font-semibold">Change Invite Code</h3>
					<div class="flex space-x-2">
						<Input
							type="text"
							placeholder="Enter new invite code"
							bind:value={newInviteCode}
						/>
						<Button on:click={changeInviteCode}>Change</Button>
					</div>
				</div>
			{/if}
			<h3 class="mb-2 mt-4 text-lg font-semibold">Members</h3>
			{#if group.members && group.members.length > 0}
				<ul class="list-disc pl-4">
					{#each group.members as memberId}
						<li class="flex items-center justify-between">
							{memberId}
							<Button
								variant="secondary"
								size="sm"
								on:click={() => removeMember(memberId)}>Remove</Button
							>
						</li>
					{/each}
				</ul>
			{:else}
				<p>No members in this group.</p>
			{/if}
			<div class="mt-4">
				<h3 class="mb-2 text-lg font-semibold">Add Member</h3>
				<div class="flex space-x-2">
					<Input
						type="email"
						placeholder="Enter member email"
						bind:value={newMemberEmail}
					/>
					<Button on:click={addMember}>Add</Button>
				</div>
			</div>
		</Card.Root>
	{:else}
		<p>Group not found.</p>
	{/if}
</div>
