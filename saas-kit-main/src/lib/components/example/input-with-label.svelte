<script lang="ts">
	import { Input } from "$lib/components/ui/input/index.js";
	import { Label } from "$lib/components/ui/label/index.js";
</script>

<div class="grid w-full max-w-sm items-center gap-1.5">
	<Label for="email">Email</Label>
	<Input type="email" id="email" placeholder="email" />
</div>
