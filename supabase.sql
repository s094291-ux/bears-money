-- 🐻‘s Money / Supabase Database
-- 在 Supabase SQL Editor 一次貼上執行。
-- 這份 SQL 已包含每位使用者只能看到自己的資料的 RLS。

create extension if not exists pgcrypto;

create table if not exists public.accounts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  type text not null default '銀行',
  opening_balance numeric(12,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null check (type in ('income','expense','transfer')),
  amount numeric(12,2) not null check (amount >= 0),
  date date not null default current_date,
  account_id uuid references public.accounts(id) on delete set null,
  category text,
  note text,
  transfer_direction text check (transfer_direction in ('in','out')),
  created_at timestamptz not null default now()
);

create table if not exists public.preorders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  total_amount numeric(12,2) not null default 0,
  paid_amount numeric(12,2) not null default 0,
  platform text,
  expected_date date,
  status text not null default 'waiting' check (status in ('waiting','partial','unpaid','paid','cancelled')),
  created_at timestamptz not null default now()
);

create table if not exists public.installments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  total_amount numeric(12,2) not null default 0,
  total_periods integer not null default 1,
  period_amount numeric(12,2) not null default 0,
  paid_periods integer not null default 0,
  remaining_amount numeric(12,2) not null default 0,
  start_date date,
  due_day integer default 5 check (due_day between 1 and 28),
  status text not null default 'active' check (status in ('active','completed','cancelled')),
  created_at timestamptz not null default now()
);

create table if not exists public.bills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  amount numeric(12,2) not null default 0,
  due_day integer not null default 5 check (due_day between 1 and 31),
  status text not null default 'unpaid' check (status in ('unpaid','paid')),
  created_at timestamptz not null default now()
);

create table if not exists public.goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  target_amount numeric(12,2) not null default 0,
  current_amount numeric(12,2) not null default 0,
  target_date date,
  created_at timestamptz not null default now()
);

alter table public.accounts enable row level security;
alter table public.transactions enable row level security;
alter table public.preorders enable row level security;
alter table public.installments enable row level security;
alter table public.bills enable row level security;
alter table public.goals enable row level security;

drop policy if exists "accounts own data" on public.accounts;
create policy "accounts own data" on public.accounts for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "transactions own data" on public.transactions;
create policy "transactions own data" on public.transactions for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "preorders own data" on public.preorders;
create policy "preorders own data" on public.preorders for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "installments own data" on public.installments;
create policy "installments own data" on public.installments for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "bills own data" on public.bills;
create policy "bills own data" on public.bills for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "goals own data" on public.goals;
create policy "goals own data" on public.goals for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create index if not exists transactions_user_date_idx on public.transactions(user_id, date desc);
create index if not exists accounts_user_idx on public.accounts(user_id);
create index if not exists preorders_user_idx on public.preorders(user_id);
create index if not exists installments_user_idx on public.installments(user_id);
create index if not exists bills_user_idx on public.bills(user_id);
create index if not exists goals_user_idx on public.goals(user_id);
