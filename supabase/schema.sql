create table if not exists public.entrelinhas_user_workspaces (
  user_id uuid primary key references auth.users(id) on delete cascade,
  workspace_data jsonb not null default jsonb_build_object(
    'projects', jsonb_build_array(),
    'documents', jsonb_build_array(),
    'calls', jsonb_build_array()
  ),
  updated_at timestamptz not null default now()
);

alter table public.entrelinhas_user_workspaces enable row level security;

drop policy if exists "Entrelinhas users manage their own workspace" on public.entrelinhas_user_workspaces;
create policy "Entrelinhas users manage their own workspace"
on public.entrelinhas_user_workspaces
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

insert into storage.buckets (id, name, public)
values ('entrelinhas-project-files', 'entrelinhas-project-files', false)
on conflict (id) do update set public = false;

drop policy if exists "Entrelinhas users read their own project files" on storage.objects;
create policy "Entrelinhas users read their own project files"
on storage.objects
for select
to authenticated
using (bucket_id = 'entrelinhas-project-files' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Entrelinhas users upload their own project files" on storage.objects;
create policy "Entrelinhas users upload their own project files"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'entrelinhas-project-files' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Entrelinhas users update their own project files" on storage.objects;
create policy "Entrelinhas users update their own project files"
on storage.objects
for update
to authenticated
using (bucket_id = 'entrelinhas-project-files' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'entrelinhas-project-files' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Entrelinhas users delete their own project files" on storage.objects;
create policy "Entrelinhas users delete their own project files"
on storage.objects
for delete
to authenticated
using (bucket_id = 'entrelinhas-project-files' and (storage.foldername(name))[1] = auth.uid()::text);
