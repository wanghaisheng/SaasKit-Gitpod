<script lang="ts">
  import { supabase } from '$lib/supabaseClient';
  import { onMount } from 'svelte';

  interface Group {
    id: string;
    name: string;
    owner_id: string;
    created_at: string;
  }

  let groups: Group[] = [];
  let groupName = '';

  // Fetch groups on page load
  onMount(async () => {
    const { data, error } = await supabase
      .from('groups')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching groups:', error);
    } else if (data) {
      groups = data as Group[];
    }
  });

  // Create a new group
  async function createGroup() {
    const { data, error } = await supabase
      .from('groups')
      .insert([{ name: groupName }]);

    if (error) {
      console.error('Error creating group:', error);
    } else if (data) {
      groups = [data[0] as Group, ...groups];
      groupName = '';
    }
  }
</script>

<h1>Groups</h1>

<form on:submit|preventDefault={createGroup}>
  <input
    type="text"
    placeholder="Group Name"
    bind:value={groupName}
    required
  />
  <button type="submit">Create Group</button>
</form>

<ul>
  {#each groups as group}
    <li>{group.name}</li>
  {/each}
</ul>