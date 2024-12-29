-- Create a table for tee time participants
create table tee_time_participants (
  id uuid primary key default gen_random_uuid(),
  tee_time_id uuid references tee_times(id) on delete cascade not null,
  user_id uuid references profiles(id) on delete cascade not null,
  created_at timestamp with time zone default now()
);

-- Enable Row Level Security (RLS) for tee_time_participants
alter table tee_time_participants enable row level security;

-- Policies for tee_time_participants
create policy "Users can view their tee time participations" on tee_time_participants
  for select using (auth.uid() = user_id);

create policy "Group members can manage tee time participations" on tee_time_participants
  for all using (
    auth.uid() in (
      select user_id from group_members where group_id = (
        select group_id from tee_times where id = tee_time_participants.tee_time_id
      )
    )
  );