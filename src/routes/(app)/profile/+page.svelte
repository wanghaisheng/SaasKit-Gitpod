<script lang="ts">
	import {
		type Infer,
		type SuperValidated,
		superForm,
	} from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import * as Form from '$lib/components/ui/form';
	import { Input } from '$lib/components/ui/input';
	import { Button } from '$lib/components/ui/button';
	import { Textarea } from '$lib/components/ui/textarea';
	import { cn } from '$lib/utils';
	import { browser } from '$app/environment';
	import { z } from 'zod';

	const profileFormSchema = z.object({
		username: z
			.string()
			.min(2, 'Username must be at least 2 characters.')
			.max(30, 'Username must not be longer than 30 characters'),
		email: z
			.string({ required_error: 'Please select an email to display' })
			.email(),
		bio: z.string().min(4).max(160).default(''),
	});
	type ProfileFormSchema = typeof profileFormSchema;

	export let data: SuperValidated<Infer<ProfileFormSchema>>;

	const form = superForm(data, {
		validators: zodClient(profileFormSchema),
	});

	const { form: formData, enhance } = form;
</script>

<div class="container mx-auto p-4">
	<h1 class="mb-4 text-3xl font-bold">User Profile</h1>
	<form method="POST" class="space-y-8" use:enhance>
		<Form.Field {form} name="username">
			<Form.Control let:attrs>
				<Form.Label>Username</Form.Label>
				<Input
					placeholder="@shadcn"
					{...attrs}
					bind:value={$formData.username}
				/>
			</Form.Control>
			<Form.Description>This is your public display name.</Form.Description>
			<Form.FieldErrors />
		</Form.Field>

		<Form.Field {form} name="email">
			<Form.Control let:attrs>
				<Form.Label>Email</Form.Label>
				<Input
					type="email"
					placeholder="email@example.com"
					{...attrs}
					bind:value={$formData.email}
				/>
			</Form.Control>
			<Form.Description>This is your email address.</Form.Description>
			<Form.FieldErrors />
		</Form.Field>

		<Form.Field {form} name="bio">
			<Form.Control let:attrs>
				<Form.Label>Bio</Form.Label>
				<Textarea {...attrs} bind:value={$formData.bio} />
			</Form.Control>
			<Form.Description>Tell us a little about yourself.</Form.Description>
			<Form.FieldErrors />
		</Form.Field>

		<Button type="submit">Update profile</Button>
	</form>
</div>
