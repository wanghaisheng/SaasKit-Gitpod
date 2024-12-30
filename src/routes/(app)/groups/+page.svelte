<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input';
	import { Label } from '$lib/components/ui/label';
	import * as Card from '$lib/components/ui/card';
	import { onMount } from 'svelte';
	import { supabase } from '$lib/supabaseClient';

	interface Group {
		id: number;
		name: string;
		owner_id: string;
		members: string[];
		invite_code: string;
	}

	let groups: Group[] = [];
	let user: any = null;
	let newGroupName: string = '';
	let inviteEmails: string[] = ['', '', '', ''];
	let newInviteCode: string = '';

	onMount(async () => {
		const {
			data: { user: supabaseUser },
		} = await supabase.auth.getUser();
		user = supabaseUser;

		if (user) {
			// Fetch groups from database
			const { data: groupsData, error: groupsError } = await supabase
				.from('groups')
				.select('*')
				.or(`owner_id.eq.${user.id},members.cs.{${user.id}}`);

			if (groupsError) {
				console.error('Error fetching groups:', groupsError);
				return;
			}

			groups = groupsData || [];
		}
	});

	async function createGroup() {
		if (!user) return;

		const { data: groupData, error: groupError } = await supabase
			.from('groups')
			.insert({
				name: newGroupName,
				owner_id: user.id,
				invite_code: newInviteCode,
			})
			.select()
			.single();

		if (groupError) {
			console.error('Error creating group:', groupError);
			return;
		}

		if (groupData) {
			let newMembers = [];
			for (const email of inviteEmails) {
				if (email) {
					const { data: userData, error: userError } = await supabase
						.from('users')
						.select('id')
						.eq('email', email)
						.single();

					if (userError) {
						console.error('Error fetching user:', userError);
					} else if (userData) {
						newMembers.push(userData.id);
					}
				}
			}

			if (newMembers.length > 0) {
				const { error: updateError } = await supabase
					.from('groups')
					.update({ members: newMembers })
					.eq('id', groupData.id);

				if (updateError) {
					console.error('Error adding members:', updateError);
				}
			}
			groups = [...groups, groupData];
			newGroupName = '';
			inviteEmails = ['', '', '', ''];
			newInviteCode = '';
		}
	}
</script>

<div class="container mx-auto p-4">
	<h1 class="mb-4 text-3xl font-bold">Manage Groups</h1>
	<div class="grid grid-cols-2 gap-4">
		<div>
			<h2 class="mb-2 text-xl font-semibold">Create Group</h2>
			<form class="space-y-4" on:submit|preventDefault={createGroup}>
				<div>
					<Label for="name">Name</Label>
					<Input type="text" id="name" bind:value={newGroupName} />
				</div>
				<div>
					<Label for="inviteCode">Invite Code</Label>
					<Input type="text" id="inviteCode" bind:value={newInviteCode} />
				</div>
				<div class="space-y-2">
					<Label>Invite Friends (Optional)</Label>
					{#each inviteEmails as email, i}
						<Input
							type="email"
							placeholder="Enter email"
							bind:value={inviteEmails[i]}
						/>
					{/each}
				</div>
				<Button type="submit">Create Group</Button>
			</form>
		</div>
		<div>
			<h2 class="mb-2 text-xl font-semibold">My Groups</h2>
			{#each groups as group}
				<a href="/(app)/groups/{group.id}">
					<Card.Root
						class="mb-2 rounded-md border p-2 transition-colors hover:bg-gray-100"
					>
						<p>Name: {group.name}</p>
						{#if group.owner_id === user?.id}
							<p class="text-sm text-gray-500">Owner</p>
						{/if}
					</Card.Root>
				</a>
			{/each}
		</div>
	</div>
</div>
