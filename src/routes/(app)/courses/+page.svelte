<script lang="ts">
  import { Button } from '$lib/components/ui/button'
  import { Input } from '$lib/components/ui/input'
  import { Label } from '$lib/components/ui/label'
  import { onMount } from 'svelte';

  let map;
  let mapboxgl;

  onMount(async () => {
    mapboxgl = await import('mapbox-gl');
    mapboxgl.accessToken = import.meta.env.VITE_MAPBOX_API_KEY;

    map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v12',
      center: [-96, 37.8],
      zoom: 3
    });
  });
</script>

<div class="container mx-auto p-4">
  <h1 class="text-3xl font-bold mb-4">Manage Courses</h1>
  <div class="grid grid-cols-2 gap-4">
    <div>
      <h2 class="text-xl font-semibold mb-2">Add New Course</h2>
      <form class="space-y-4">
        <div>
          <Label for="courseName">Course Name</Label>
          <Input type="text" id="courseName" />
        </div>
        <div>
          <Label for="courseAddress">Address</Label>
          <Input type="text" id="courseAddress" />
        </div>
        <Button type="submit">Add Course</Button>
      </form>
    </div>
    <div>
      <h2 class="text-xl font-semibold mb-2">Search Courses</h2>
      <div id="map" style="height: 400px;"></div>
    </div>
  </div>
</div>