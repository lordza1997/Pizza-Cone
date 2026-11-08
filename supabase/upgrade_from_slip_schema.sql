-- ใช้ครั้งเดียวเมื่อเคยสร้าง public.orders ด้วย schema รุ่นที่มี slip_url NOT NULL
-- คำสั่งนี้เก็บข้อมูลและไฟล์เดิมไว้ เพียงอนุญาตให้ออเดอร์ใหม่ไม่มี slip_url
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'orders'
      and column_name = 'slip_url'
  ) then
    execute 'alter table public.orders alter column slip_url drop not null';
  end if;
end
$$;
