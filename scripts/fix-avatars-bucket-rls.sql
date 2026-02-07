-- แก้ RLS บน Storage bucket "avatars"
--
-- ⚠️ ถ้ารันแล้วได้: ERROR: must be owner of table objects
--    ตาราง storage.objects เป็นของระบบ Supabase ต้องตั้ง policy ผ่าน Dashboard แทน
--    ดูวิธีทำในไฟล์: setup-avatars-bucket-via-dashboard.md
--
-- ถ้าโปรเจกต์คุณรัน SQL ใต้ storage ได้ ให้รันส่วน CREATE POLICY ด้านล่าง
-- (ลบบรรทัด DROP ออกก่อนถ้า DROP ก็ error)

-- อัปโหลดได้เฉพาะโฟลเดอร์ที่เป็น user id ของตัวเอง (path = auth.uid()/...)
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- อัปเดต (upsert) ได้เฉพาะไฟล์ในโฟลเดอร์ของตัวเอง
CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE TO authenticated
USING (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
)
WITH CHECK (
  bucket_id = 'avatars'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- อ่านได้ทุกคน (เพื่อให้ getPublicURL ใช้ได้)
CREATE POLICY "Anyone can read avatars"
ON storage.objects FOR SELECT TO public
USING (bucket_id = 'avatars');
