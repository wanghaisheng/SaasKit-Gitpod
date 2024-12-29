<script lang="ts">
  import { supabase } from '$lib/supabaseClient';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';

  interface TeeTime {
    id: string;
    group_id: string;
    date: string;
    time: string;
    max_players: number;
    notes: string | null;
    created_at: string;
  }

  let teeTimes: TeeTime[] = [];
  let date = '';
  let time = '';
  let maxPlayers = 0;
  let notes = '';
  const groupId = $page.params.groupId;

  // Fetch tee times on page load
  onMount(async () => {
    const { data, error } = await supabase
      .from('tee_times')
      .select('*')
      .eq('group_id', groupId);

    if (error) {
      console.error('Error fetching tee times:', error);
    } else if (data) {
      teeTimes = data as TeeTime[];
    }
  });

  // Create a new tee time
  async function createTeeTime() {
    const { data, error } = await supabase
      .from('tee_times')
      .insert([{ group_id: groupId, date, time, max_players: maxPlayers, notes }]);

    if (error) {
      console.error('Error creating tee time:', error);
    } else if (data) {
      teeTimes = [data[0] as TeeTime, ...teeTimes];
      date = '';
      time = '';
      maxPlayers = 0;
      notes = '';
    }
  }
</script>

<h1>Tee Times</h1>

<form on:submit|preventDefault={createTeeTime}>
  <input type="date" bind:value={date} required />
  <input type="time" bind:value={time} required />
  <input type="number" placeholder="Max Players" bind:value={maxPlayers} required />
  <input type="text" placeholder="Notes" bind:value={notes} />
  <button type="submit">Create Tee Time</button>
</form>

<ul>
  {#each teeTimes as teeTime}
    <li>
      {new Date(teeTime.date).toLocaleDateString()} - {teeTime.time} - Max Players: {teeTime.max_players}
      {#if teeTime.notes}
        - Notes: {teeTime.notes}
      {/if}
    </li>
  {/each}
</ul>