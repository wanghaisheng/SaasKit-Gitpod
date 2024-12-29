<script lang="ts">
	import { Avatar as AvatarPrimitive } from 'bits-ui';
	import { cn } from '$lib/utils.js';

	export let ref = null;
	export let className = '';
</script>

<AvatarPrimitive.Fallback
	bind:ref
	class={cn(
		'flex h-full w-full items-center justify-center rounded-full bg-muted',
		className,
	)}
	{...$$restProps}
>
	<slot />
</AvatarPrimitive.Fallback>
