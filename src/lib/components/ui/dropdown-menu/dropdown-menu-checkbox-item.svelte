<script lang="ts">
	import { DropdownMenu as DropdownMenuPrimitive } from 'bits-ui';
	import { Check } from 'lucide-svelte';
	import { Minus } from 'lucide-svelte';
	import { cn } from '$lib/utils.js';

	export let ref = null;
	export let className: string | undefined = undefined;
	export let checked = false;
	export let indeterminate = false;
	export { className as class };
</script>

<DropdownMenuPrimitive.CheckboxItem
	bind:ref
	bind:checked
	bind:indeterminate
	class={cn(
		'relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none',
		'data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground',
		'data-[disabled]:pointer-events-none data-[disabled]:opacity-50',
		className,
	)}
	{...$$restProps}
>
	<span class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
		{#if indeterminate}
			<Minus class="h-4 w-4" />
		{:else}
			<Check class={cn('h-4 w-4', !checked && 'text-transparent')} />
		{/if}
	</span>
	<slot />
</DropdownMenuPrimitive.CheckboxItem>
