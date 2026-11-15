-- Run this once in Supabase SQL Editor if saving the menu reports that
-- public.menu_config is missing. Existing order data is not changed.
create table if not exists public.menu_config (
  id integer primary key check (id = 1),
  config jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.menu_config enable row level security;
revoke all on public.menu_config from anon, authenticated;
grant all on public.menu_config to service_role;

insert into public.menu_config (id, config)
values (
  1,
  '{"sizes":[{"id":7,"p":25,"q":2,"c":"ชีสมาตรฐาน"},{"id":9,"p":35,"q":3,"c":"ชีสเพิ่มขึ้น"},{"id":11,"p":40,"q":4,"c":"ชีสพูน ๆ"}],"regular":["แฮม","ไส้กรอก","โบโลน่า","ปูอัด","ข้าวโพด","สับปะรด","เบคอน","กุ้ง","ปลาหมึก","ทูน่า","เบิ้ลชีส"],"sauces":["ซอสมะเขือเทศเข้มข้นสไตล์พิซซ่า","ซอสบาร์บีคิว","ซอสสไปซี่"]}'::jsonb
)
on conflict (id) do nothing;
