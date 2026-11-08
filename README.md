# Pizza Cone Ordering

เว็บสั่งพิซซ่าโคนหน้าเดียวด้วย React, Node.js/Express, Vite และ Supabase

## ตั้งค่า Supabase
1. เปิด Supabase SQL Editor แล้วรัน `supabase/schema.sql`
2. ตั้งค่า environment variables ของเซิร์ฟเวอร์ตาม `.env.example`; ห้าม commit `.env.local` หรือคีย์ลับ
3. สำหรับ deploy ดูขั้นตอนในหัวข้อถัดไป

## Deploy สาธารณะ
repository นี้มี `render.yaml` สำหรับสร้าง Render Web Service ฟรีและเผยแพร่ URL `onrender.com`. ใน Render เลือก New → Blueprint แล้วเชื่อม repository นี้ จากนั้นกรอกตัวแปร Supabase และรหัสผ่านแอดมินในหน้า Environment ของ Render. กำหนด `SESSION_SECRET` ใหม่แบบสุ่มอย่างน้อย 32 ตัวอักษร.