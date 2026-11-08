# Pizza Cone Ordering

เว็บสั่งพิซซ่าโคนหน้าเดียวด้วย React, Node.js/Express, Vite, Tailwind CSS และ Supabase Database/Realtime. ระบบไม่มีการแนบหรือจัดเก็บสลิป

## ตั้งค่า Supabase
1. สร้างโปรเจกต์ Supabase แล้วเปิด SQL Editor
2. รัน supabase/schema.sql เพื่อสร้าง/อัปเดตตาราง orders, เมนูที่ปรับได้ menu_config, ตาราง feed สถานะ order_status, trigger และ Realtime publication. สำหรับฐานข้อมูลเดิมให้รันไฟล์นี้ซ้ำเพื่อเพิ่มตารางตั้งค่าเมนูและปรับข้อจำกัดขนาด/ซอส
3. จาก Project Settings → API Keys คัดลอก Project URL, Publishable key และ Secret key. ใส่ Publishable key ใน VITE_SUPABASE_ANON_KEY และ Secret key ใน SUPABASE_SERVICE_ROLE_KEY
4. ใส่ค่าลง .env.local: server URL/key, รหัสผ่าน ADMIN_PASSWORD, ค่า SESSION_SECRET แบบสุ่มอย่างน้อย 32 ตัวอักษร, browser URL/key
5. ห้ามใส่ Secret/service_role key ในตัวแปร VITE_*. หากมีตารางจาก schema เก่าที่กำหนด slip_url เป็น NOT NULL ให้รัน supabase/upgrade_from_slip_schema.sql ด้วย

## เริ่มใช้งาน
ใช้ Node.js 20+. รัน npm install แล้ว npm run dev; เปิด Vite URL ที่แสดง (ทั่วไป http://localhost:5173). Dashboard ร้านอยู่ที่ /admin. Production: npm run build, ตั้ง NODE_ENV=production, แล้ว npm start.

## เปิดเว็บให้คนทั่วไปเข้าผ่านลิงก์
โปรเจกต์มี `render.yaml` สำหรับสร้าง Web Service บน Render Free ซึ่งจะได้ URL สาธารณะรูปแบบ `https://ชื่อบริการ.onrender.com` โดยไม่ต้องซื้อโดเมนก่อน บริการฟรีจะพักหลังไม่มีผู้เข้าชม 15 นาที และการเปิดครั้งแรกหลังพักอาจใช้เวลาประมาณหนึ่งนาที

1. เก็บ source code ใน GitHub repository (ตั้งเป็น Private ได้; ตัวเว็บไซต์ยังเปิดให้ทุกคนเข้าถึงได้) แล้ว push โปรเจกต์ขึ้น repository โดยไม่รวม `.env.local` หรือ key ลับ
2. ใน Render Dashboard เลือก **New → Blueprint** แล้วเชื่อม repository นี้ จากนั้น Render จะอ่าน `render.yaml`
3. กรอก `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `ADMIN_PASSWORD`, `VITE_SUPABASE_URL` และ `VITE_SUPABASE_ANON_KEY` ในขั้นตอนตั้งค่า environment variables; `SESSION_SECRET` ถูกสร้างให้อัตโนมัติ
4. ตรวจว่าได้รัน `supabase/schema.sql` ใน Supabase แล้ว จากนั้น deploy และใช้ URL `.onrender.com` ที่ Render แสดงเพื่อแชร์ให้ทุกคน

ถ้าต้องการโดเมนที่กำหนดเอง เช่น `.com` ต้องมีโดเมนนั้นก่อน แล้วเพิ่มใน Render และตั้งค่า DNS กับผู้ให้บริการโดเมน Render Free รองรับ custom domain และออก TLS certificate ให้อัตโนมัติ

ลูกค้ากรอกชื่อ เลือกไซส์ ไส้ และซอส แล้วส่งออเดอร์ได้เลย. แอดมินตรวจรายการและกด “ยืนยันออเดอร์และส่งเข้าครัว” เพื่อเปลี่ยนเป็น cooking; เมื่อเสร็จให้กดพร้อมรับ. สถานะ ready อัปเดตที่หน้าลูกค้าผ่าน Realtime.

แอดมินที่ /admin สามารถแก้ไขรายการไส้และซอส เพิ่ม/ลบขนาด ตั้งราคา และกำหนดจำนวนไส้ที่เลือกได้ต่อขนาดได้ เมนูจะบันทึกใน Supabase และถูกใช้ตรวจสอบออเดอร์ฝั่งเซิร์ฟเวอร์. ไม่มีหน้าชำระเงินหรือแนบสลิป.

หากเคยรัน schema รุ่นเก่าที่มี slip_url หรือ bucket pizza-slips, เวอร์ชันนี้จะไม่ใช้สิ่งเหล่านั้นแล้ว และจะไม่ลบคอลัมน์หรือไฟล์เดิมให้อัตโนมัติ เพื่อเก็บข้อมูลเก่าไว้. ตาราง/bucket เดิมไม่มีผลต่อการสั่งงานใหม่.

