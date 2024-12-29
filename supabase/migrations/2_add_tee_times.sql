-- Create a table for tee times
create table if not exists tee_times (
 id uuid primary key default gen_random_uuid(), 
 group_id uuid references groups(id) on delete cascade not null,
 date date not null,
 time time not null,
 max_players int not null,
 notes text,
 created_at timestamp with time zone default now()
);

-- Enable Row Level Security (RLS) for tee_times
alter table if exists tee_times enable row level security;

-- Drop existing policies if they exist
drop policy if exists "Group members can view tee times" on tee_times;
drop policy if exists "Group admins can manage tee times" on tee_times;

-- Create policies for tee_times
create policy "Group members can view tee times" on tee_times
 for select using (
   auth.uid() in (
     select user_id from group_members where group_id = tee_times.group_id
   )
 );

create policy "Group admins can manage tee times" on tee_times
 for all using (
   auth.uid() = (
     select owner_id from groups where id = tee_times.group_id
   )
 );