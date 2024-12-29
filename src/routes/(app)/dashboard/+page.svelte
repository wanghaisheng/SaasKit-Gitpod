<script lang="ts">
  import Dashboard07 from '$lib/components/ui/dashboard-07.svelte';
  import { onMount } from 'svelte';
  import { supabase } from '$lib/supabaseClient';

  interface Group {
    id: number;
    name: string;
  }

  interface TeeTime {
    id: number;
    date: string;
    time: string;
    course: string;
  }

  let groups: Group[] = [];
  let teeTimes: TeeTime[] = [];

  onMount(async () => {
    // Fetch groups and tee times from database
    const { data: groupsData, error: groupsError } = await supabase
      .from('groups')
      .select('*');

    if (groupsError) {
      console.error('Error fetching groups:', groupsError);
      return;
    }

    groups = groupsData || [];

    const { data: teeTimesData, error: teeTimesError } = await supabase
      .from('tee_times')
      .select('*');

    if (teeTimesError) {
      console.error('Error fetching tee times:', teeTimesError);
      return;
    }

    teeTimes = teeTimesData || [];
  });
</script>

<svelte:head>
  <title>Dashboard</title>
</svelte:head>

<Dashboard07 />
