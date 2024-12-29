-- Create a table for groups
create table groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner_id uuid references profiles(id) on delete cascade not null,
  created_at timestamp with time zone default now()
);

-- Create a table for group members
create table group_members (
  id uuid primary key default gen_random_uuid(),
  group_id uuid references groups(id) on delete cascade not null,
  user_id uuid references profiles(id) on delete cascade not null,
  role text check (role in ('member', 'admin')) not null,
  created_at timestamp with time zone default now()
);

-- Enable Row Level Security (RLS) for groups
alter table groups enable row level security;

-- Enable Row Level Security (RLS) for group_members
alter table group_members enable row level security;

-- Policies for groups
create policy "Group owners can manage their groups" on groups
  for all using (auth.uid() = owner_id);

-- Policies for group_members
create policy "Group members can view their membership" on group_members
  for select using (auth.uid() = user_id);

create policy "Group admins can manage membership" on group_members
  for all using (
    auth.uid() = (select owner_id from groups where id = group_id)
  );