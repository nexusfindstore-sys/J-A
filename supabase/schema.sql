-- Run this once in the Supabase SQL Editor. Keep the service-role key private.
create extension if not exists pgcrypto;
create table if not exists public.wishes (
  id uuid primary key default gen_random_uuid(),
  guest_name text not null check (char_length(guest_name) between 1 and 48),
  relationship text check (char_length(relationship) <= 80),
  message text not null check (char_length(message) between 1 and 280),
  approved boolean not null default false,
  created_at timestamptz not null default now(),
  ip_hash text
);
create table if not exists public.rsvps (
  id uuid primary key default gen_random_uuid(),
  guest_name text not null check (char_length(guest_name) between 1 and 80),
  phone text, attending boolean not null,
  party_size integer not null check (party_size between 0 and 12),
  additional_names text check (char_length(additional_names) <= 300),
  message text check (char_length(message) <= 280),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (guest_name)
);
alter table public.wishes enable row level security;
alter table public.rsvps enable row level security;
create policy "Public reads approved wishes" on public.wishes for select using (approved = true);
create policy "Public sends wishes" on public.wishes for insert with check (approved = false);
create policy "Public reads attendance totals" on public.rsvps for select using (true);
create policy "Public sends one RSVP" on public.rsvps for insert with check (party_size >= 0);
-- Do NOT add public update/delete policies. Couple signs into Supabase Dashboard to approve/hide wishes or manage RSVPs.
create or replace view public.attendance_summary as
select coalesce(sum(case when attending then party_size else 0 end),0)::int as confirmed_guests,
 count(*) filter (where attending)::int as confirmed_rsvps,
 count(*) filter (where not attending)::int as declined_rsvps
from public.rsvps;
grant select on public.attendance_summary to anon;
