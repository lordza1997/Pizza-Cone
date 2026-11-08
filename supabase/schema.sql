create extension if not exists pgcrypto;

create table if not exists public.orders(
 id uuid primary key default gen_random_uuid(),
 customer_name text not null check(char_length(trim(customer_name)) between 1 and 60),
 size integer not null check(size between 1 and 100),
 toppings text[] not null check(cardinality(toppings)>=1),
 sauce text not null check(char_length(trim(sauce)) between 1 and 80),
 total_price integer not null check(total_price>0),
 status text not null default 'pending' check(status in('pending','cooking','ready')),
 created_at timestamptz not null default now()
);
-- Keep existing order rows intact while allowing the admin to add menu options.
alter table public.orders drop constraint if exists orders_size_check;
alter table public.orders drop constraint if exists orders_sauce_check;
alter table public.orders add constraint orders_size_check check(size between 1 and 100);
alter table public.orders add constraint orders_sauce_check check(char_length(trim(sauce)) between 1 and 80);

create table if not exists public.menu_config(
 id integer primary key check(id=1),
 config jsonb not null,
 updated_at timestamptz not null default now()
);
alter table public.menu_config enable row level security;
revoke all on public.menu_config from anon,authenticated;
insert into public.menu_config(id,config) values(1,'{"sizes":[{"id":7,"p":25,"q":2,"c":"ชีสมาตรฐาน"},{"id":9,"p":35,"q":3,"c":"ชีสเพิ่มขึ้น"},{"id":11,"p":40,"q":4,"c":"ชีสพูน ๆ"}],"regular":["แฮม","ไส้กรอก","โบโลน่า","ปูอัด","ข้าวโพด","สับปะรด","เบคอน","กุ้ง","ปลาหมึก","ทูน่า","เบิ้ลชีส"],"sauces":["ซอสมะเขือเทศเข้มข้นสไตล์พิซซ่า","ซอสบาร์บีคิว","ซอสสไปซี่"]}'::jsonb) on conflict(id) do nothing;
alter table public.orders enable row level security;
revoke all on public.orders from anon,authenticated;

-- Realtime feed contains only an order UUID and status, no customer details.
create table if not exists public.order_status(
 order_id uuid primary key references public.orders(id) on delete cascade,
 status text not null check(status in('pending','cooking','ready')),
 updated_at timestamptz not null default now()
);
alter table public.order_status enable row level security;
revoke all on public.order_status from anon,authenticated;
grant select on public.order_status to anon,authenticated;
drop policy if exists "Read public status feed" on public.order_status;
create policy "Read public status feed" on public.order_status for select to anon,authenticated using(true);

create or replace function public.sync_order_status() returns trigger language plpgsql security definer set search_path='' as $$
begin
 insert into public.order_status(order_id,status,updated_at) values(new.id,new.status,now())
 on conflict(order_id) do update set status=excluded.status,updated_at=excluded.updated_at;
 return new;
end;$$;
drop trigger if exists sync_order_status on public.orders;
create trigger sync_order_status after insert or update of status on public.orders for each row execute function public.sync_order_status();

do $$begin
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='order_status') then
  alter publication supabase_realtime add table public.order_status;
 end if;
end$$;

