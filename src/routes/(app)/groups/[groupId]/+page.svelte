<script lang="ts">
  import { supabase } from '$lib/supabaseClient';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';

  interface Group {
    id: string;
    name: string;
    owner_id: string;
    created_at: string;
  }

  interface Member {
    id: string;
    user_id: string;
    role: 'member' | 'admin';
    created_at: string;
  }

  let group: Group | null = null;
  let members: Member[] = [];
  const groupId = $page.params.groupId;

  // Fetch group details and members on page load
  onMount(async () => {
    const { data: groupData, error: groupError } = await supabase
      .from('groups')
      .select('*')
      .eq('id', groupId)
      .single();

    if (groupError) {
      console.error('Error fetching group details:', groupError);
    } else {
      group = groupData as Group;
    }

    const { data: membersData, error: membersError } = await supabase
      .from('group_members')
      .select('*')
      .eq('group_id', groupId);

    if (membersError) {
      console.error('Error fetching members:', membersError);
    } else if (membersData) {
      members = membersData as Member[];
    }
  });
</script>

<h1>Group Details</h1>

{#if group}
  <h2>{group.name}</h2>
  <p>Owner ID: {group.owner_id}</p>
  <p>Created At: {new Date(group.created_at).toLocaleString()}</p>

  <h3>Members</h3>
  <ul>
    {#each members as member}
      <li>
        {member.user_id} - {member.role}
      </li>
    {/each}
  </ul>

  <a href={`/groups/${groupId}/members`}>Manage Members</a>
{/if}

{#if !group}
  <p>Loading group details...</p>
{/if}