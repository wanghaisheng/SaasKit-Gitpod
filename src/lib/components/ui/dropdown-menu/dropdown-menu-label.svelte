<script lang="ts">
	import { cn } from '$lib/utils.js';
	import type { HTMLAttributes } from 'svelte/elements';

	export let ref: HTMLDivElement | null = null;
	export let inset = false;
	let className: string | undefined = undefined;
	export { className as class };
</script>

<div
	bind:this={ref}
	class={cn('px-2 py-1.5 text-sm font-semibold', inset && 'pl-8', className)}
	{...$$restProps}
>
	<slot />
</div>
