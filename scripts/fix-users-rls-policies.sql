-- แก้ error "new row violates row-level security policy" บนตาราง public.users
-- วิธีใช้: Supabase Dashboard → SQL Editor → วางทั้งหมด → Run

-- เปิด RLS ถ้ายังไม่เปิด
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- ลบ policy เก่าที่อาจชนกัน
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
DROP POLICY IF EXISTS "Users can read own profile" ON public.users;
DROP POLICY IF EXISTS "Allow users to update their own profile" ON public.users;
DROP POLICY IF EXISTS "Allow users to view their own profile" ON public.users;
DROP POLICY IF EXISTS "Allow users to insert their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can view their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.users;

-- ให้ authenticated อ่าน/อัปเดต/insert ได้เฉพาะแถวของตัวเอง (id = auth.uid())
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
-- ทางเลือก: ฟังก์ชัน RPC อัปเดตโปรไฟล์ (รันด้วยสิทธิ์ definer ไม่ติด RLS)
-- แอปจะเรียกฟังก์ชันนี้แทน .update() โดยตรง
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_my_profile(
  p_display_name text DEFAULT NULL,
  p_avatar_url text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.users
  SET
    display_name = COALESCE(p_display_name, display_name),
    avatar_url   = CASE WHEN p_avatar_url IS NOT NULL AND trim(p_avatar_url) = '' THEN NULL ELSE COALESCE(p_avatar_url, avatar_url) END,
    updated_at   = now()
  WHERE id = auth.uid();
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found or not allowed';
  END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION public.update_my_profile(text, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_my_profile(text, text) TO service_role;
