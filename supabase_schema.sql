create table if not exists public.survey_dashboard_state (
  id text primary key,
  source_name text not null default 'Uploaded survey data',
  rows jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.survey_dashboard_state enable row level security;

drop policy if exists "Read shared dashboard survey data" on public.survey_dashboard_state;
drop policy if exists "Insert shared dashboard survey data" on public.survey_dashboard_state;
drop policy if exists "Update shared dashboard survey data" on public.survey_dashboard_state;

create policy "Read shared dashboard survey data"
  on public.survey_dashboard_state
  for select
  to anon, authenticated
  using (id = 'latest');

create policy "Insert shared dashboard survey data"
  on public.survey_dashboard_state
  for insert
  to anon, authenticated
  with check (id = 'latest');

create policy "Update shared dashboard survey data"
  on public.survey_dashboard_state
  for update
  to anon, authenticated
  using (id = 'latest')
  with check (id = 'latest');

grant select, insert, update on public.survey_dashboard_state to anon, authenticated;
