# Fixing Info.plist Duplicate Error

## The Problem

Modern Xcode projects (iOS 14+) auto-generate Info.plist. Adding a custom Info.plist causes a conflict.

## Solution: Use Target's Info Tab Instead

Instead of a separate Info.plist file, add the keys directly in Xcode:

### Steps:

1. **Open Xcode**
2. **Select your target** (FocusFlow (AI Task Prioritizer))
3. **Go to "Info" tab**
4. **Click the "+" button** to add custom keys
5. **Add these two keys**:
   - Key: `SUPABASE_URL`
   - Type: `String`
   - Value: `$(SUPABASE_URL)`
   - Key: `SUPABASE_ANON_KEY`
   - Type: `String`
   - Value: `$(SUPABASE_ANON_KEY)`

6. **Save** (Cmd+S)

### Alternative: Use Build Settings

If the Info tab doesn't work, use Build Settings:

1. Select your target
2. Go to "Build Settings" tab
3. Search for "Info.plist Values"
4. Add custom entries there

---

## What I Did

- ✅ Removed the custom `Info.plist` file
- ✅ You'll add the keys via Xcode UI instead

This approach works better with modern Xcode projects and avoids the duplicate file error.
