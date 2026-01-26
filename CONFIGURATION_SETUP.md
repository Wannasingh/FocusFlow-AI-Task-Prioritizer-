# Secure Supabase Configuration Setup

## ✅ What We've Done

1. **Updated `.gitignore`** - Now excludes all `.xcconfig` files
2. **Created `Config.xcconfig.template`** - Template file for team members
3. **Updated `SupabaseConfig.swift`** - Now reads from Info.plist instead of hardcoded values

## 🔐 Setup Instructions

### Step 1: Create Your Config File

1. Copy the template file:

   ```bash
   cp Config.xcconfig.template Config.xcconfig
   ```

2. Open `Config.xcconfig` and replace the placeholder values with your actual Supabase credentials:
   ```
   SUPABASE_URL = https://your-project.supabase.co
   SUPABASE_ANON_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

### Step 2: Configure Xcode Project

1. **Open your Xcode project**

2. **Add Config.xcconfig to your project:**
   - In Xcode, select the project in the navigator
   - Right-click on the project folder
   - Select "Add Files to FocusFlow..."
   - Navigate to and select `Config.xcconfig`
   - Make sure "Copy items if needed" is **unchecked**
   - Click "Add"

3. **Set the configuration file for your target:**
   - Select your project in the navigator
   - Select your target (FocusFlow (AI Task Prioritizer))
   - Go to the "Info" tab
   - Under "Configurations", expand "Debug" and "Release"
   - For both Debug and Release, set the configuration file to `Config`

4. **Add keys to Info.plist:**
   - Open `Info.plist`
   - Add two new rows:
     - Key: `SUPABASE_URL`, Type: String, Value: `$(SUPABASE_URL)`
     - Key: `SUPABASE_ANON_KEY`, Type: String, Value: `$(SUPABASE_ANON_KEY)`

### Step 3: Verify Setup

Build and run your project. If configured correctly, the app will load the Supabase credentials from your `Config.xcconfig` file.

## 🚨 Important Security Notes

1. **Never commit `Config.xcconfig`** - It's already in `.gitignore`
2. **Share the template** - Commit `Config.xcconfig.template` so team members know what to configure
3. **Document in README** - Add setup instructions to your project README
4. **Use different configs per environment** - Create `Config.Debug.xcconfig` and `Config.Release.xcconfig` for different environments

## 📝 For Team Members

When cloning this repository:

1. Copy the template: `cp Config.xcconfig.template Config.xcconfig`
2. Get Supabase credentials from your team lead
3. Update `Config.xcconfig` with the credentials
4. Build the project

## 🔄 Alternative: Using Environment Variables

For CI/CD pipelines, you can also use environment variables:

```swift
static var supabaseURL: String {
    if let envURL = ProcessInfo.processInfo.environment["SUPABASE_URL"] {
        return envURL
    }
    guard let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String else {
        fatalError("SUPABASE_URL not configured")
    }
    return url
}
```

## ✅ Benefits

- ✅ Secrets never committed to git
- ✅ Each developer has their own config
- ✅ Easy to manage multiple environments
- ✅ Follows Apple's best practices
- ✅ Compatible with CI/CD pipelines
