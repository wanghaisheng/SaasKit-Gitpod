<script lang="ts">
  import { supabase } from '$lib/supabaseClient';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';

  interface Member {
    id: string;
    user_id: string;
    role: 'member' | 'admin';
    created_at: string;
  }

  let members: Member[] = [];
  let userId = '';
  let role: 'member' | 'admin' = 'member';
  const groupId = $page.params.groupId;

  // Fetch members on page load
  onMount(async () => {
    const { data, error } = await supabase
      .from('group_members')
      .select('*')
      .eq('group_id', groupId);

    if (error) {
      console.error('Error fetching members:', error);
    } else if (data) {
      members = data as Member[];
    }
  });

  // Add a new member
  async function addMember() {
    const { data, error } = await supabase
      .from('group_members')
      .insert([{ group_id: groupId, user_id: userId, role }]);

    if (error) {
      console.error('Error adding member:', error);
    } else if (data) {
      members = [data[0] as Member, ...members];
      userId = '';
      role = 'member';
    }
  }

  // Remove a member
  async function removeMember(memberId: string) {
    const { error } = await supabase
      .from('group_members')
      .delete()
      .eq('id', memberId);

    if (error) {
      console.error('Error removing member:', error);
    } else {
      members = members.filter((member) => member.id !== memberId);
    }
  }
</script>

<h1>Manage Members</h1>

<form on:submit|preventDefault={addMember}>
  <input
    type="text"
    placeholder="User ID"
    bind:value={userId}
    required
  />
  <select bind:value={role}>
    <option value="member">Member</option>
    <option value="admin">Admin</option>
  </select>
  <button type="submit">Add Member</button>
</form>

<ul>
  {#each members as member}
    <li>
      {member.user_id} - {member.role}
      <button on:click={() => removeMember(member.id)}>Remove</button>
    </li>
  {/each}
</ul>