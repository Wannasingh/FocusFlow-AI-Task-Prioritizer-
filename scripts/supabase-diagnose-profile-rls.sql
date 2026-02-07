-- ============================================================
-- Script ตรวจสอบ RLS และหาทางแก้ไข (ตาราง public.users)
-- ใช้ใน Supabase Dashboard → SQL Editor → วางแล้วรันทีละบล็อก
-- ============================================================

-- ------------------------------------------------------------
-- 1. ดูว่า RLS เปิดอยู่หรือไม่
-- ------------------------------------------------------------
SELECT
  schemaname,
  tablename,
  rowsecurity AS rls_enabled
FROM pg_tables
WHERE schemaname = 'public' AND tablename = 'users';


-- ------------------------------------------------------------
-- 2. ดู policy ทั้งหมดบนตาราง users
-- ------------------------------------------------------------
SELECT
  policyname AS policy_name,
  cmd AS command,
  roles AS applied_to,
  qual AS using_expression,
  with_check AS with_check_expression
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'users'
ORDER BY cmd, policyname;


-- ------------------------------------------------------------
-- 3. ดูโครงสร้างคอลัมน์ (เช็คว่ามี id เป็น uuid)
-- ------------------------------------------------------------
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'users'
ORDER BY ordinal_position;


-- ------------------------------------------------------------
-- 4. ดู auth.users กับ public.users ว่า id ตรงกันไหม
-- (รันด้วย role postgres / service role เพื่อดูได้)
-- ------------------------------------------------------------
SELECT
  u.id AS public_users_id,
  u.display_name,
  u.email,
  (u.id IN (SELECT id FROM auth.users)) AS id_exists_in_auth
FROM public.users u
LIMIT 5;


-- ------------------------------------------------------------
-- 5. ทางแก้: ลบ policy ซ้ำ แล้วเหลือแค่ชุด authenticated
-- คัดลอกเฉพาะส่วนล่าง (จาก DROP ถึง CREATE สุดท้าย) ไปรันในแท็บใหม่
-- ------------------------------------------------------------

-- ลบทุก policy บน users ที่เกี่ยวกับการอ่าน/อัปเดต/insert ของ user ตัวเอง
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
DROP POLICY IF EXISTS "Users can read own profile" ON public.users;
DROP POLICY IF EXISTS "Allow users to update their own profile" ON public.users;
DROP POLICY IF EXISTS "Allow users to view their own profile" ON public.users;
DROP POLICY IF EXISTS "Allow users to insert their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can view their own profile" ON public.users;

-- สร้างใหม่เฉพาะ TO authenticated (แอปส่ง JWT ตอนล็อกอิน)
CREATE POLICY "Users can read own profile"
ON public.users FOR SELECT TO authenticated
USING (id = auth.uid());

CREATE POLICY "Users can update own profile"
ON public.users FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

CREATE POLICY "Users can insert own profile"
ON public.users FOR INSERT TO authenticated
WITH CHECK (id = auth.uid());


-- ------------------------------------------------------------
-- 6. ทดสอบ UPDATE (ถ้าต้องการ) แทนที่ UUID ด้วย id จริงจาก public.users
-- ------------------------------------------------------------
-- UPDATE public.users
-- SET display_name = 'Test Update', updated_at = now()
-- WHERE id = 'ad867f4c-0558-494e-8af9-03fa95d7359a'::uuid;


-- ============================================================
-- สรุปจากผล diagnostic
-- ============================================================
-- ถ้า (1) RLS เปิด (2) id ใน public.users ตรง auth.users (id_exists_in_auth = true)
-- แต่แอปยัง error "new row violates row-level security policy" แปลว่า
-- request จากแอปอาจไปเป็น role "anon" (ไม่มี JWT) ไม่ใช่ "authenticated"
--
-- ทำตามนี้:
-- 1. รันบล็อก 5 ด้านบน (DROP + CREATE) เพื่อเหลือ policy แค่ TO authenticated
-- 2. ในแอปเราได้เพิ่ม refreshSession() ก่อน update แล้ว – build แอปใหม่แล้วลอง Save อีกครั้ง
-- 3. ถ้ายังไม่ผ่าน: ตรวจสอบว่า Supabase Swift client ใช้ session (JWT) กับทุก request
--    หรือลอง logout แล้ว login ใหม่แล้วค่อยแก้ชื่ออีกครั้ง
