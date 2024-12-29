<script lang="ts">
	import {
		DropdownMenu as DropdownMenuPrimitive,
		type WithoutChild,
	} from 'bits-ui';
	import Circle from 'lucide-svelte/icons/circle';
	import { cn } from '$lib/utils.js';

	type $$Props = WithoutChild<DropdownMenuPrimitive.RadioItemProps>;

	export let ref = null;
	export let className = '';
	export let children: (props: { checked: boolean }) => any = () => null;
</script>

<DropdownMenuPrimitive.RadioItem
	bind:ref
	class={cn(
		'relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none data-[disabled]:pointer-events-none data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground data-[disabled]:opacity-50',
		className,
	)}
	{...$$restProps}
>
	<span class="absolute left-2 flex size-3.5 items-center justify-center">
		{#if $checked}
			<Circle class="size-2 fill-current" />
		{/if}
	</span>
	{@html children({ checked: $checked })}
</DropdownMenuPrimitive.RadioItem>
