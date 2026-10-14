create table if not exists public.user_workspaces (
  user_id uuid primary key references auth.users(id) on delete cascade,
  workspace_data jsonb not null default jsonb_build_object(
    'projects', jsonb_build_array(),
    'documents', jsonb_build_array(),
    'calls', jsonb_build_array()
  ),
  updated_at timestamptz not null default now()
);

alter table public.user_workspaces enable row level security;

drop policy if exists "Users manage their own workspace" on public.user_workspaces;
create policy "Users manage their own workspace"
on public.user_workspaces
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

insert into storage.buckets (id, name, public)
values ('project-files', 'project-files', false)
on conflict (id) do update set public = false;

drop policy if exists "Users read their own project files" on storage.objects;
create policy "Users read their own project files"
on storage.objects
for select
to authenticated
using (bucket_id = 'project-files' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users upload their own project files" on storage.objects;
create policy "Users upload their own project files"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'project-files' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users update their own project files" on storage.objects;
create policy "Users update their own project files"
on storage.objects
for update
to authenticated
using (bucket_id = 'project-files' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'project-files' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users delete their own project files" on storage.objects;
create policy "Users delete their own project files"
on storage.objects
for delete
to authenticated
using (bucket_id = 'project-files' and (storage.foldername(name))[1] = auth.uid()::text);
