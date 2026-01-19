# Java Configuration for Wheel Inspector

## Problem Summary

The `ultralytics_yolo` package requires Java 17, but Gradle cannot auto-detect your Java installation due to network/SSL restrictions. You have Java 21 installed, which is fully compatible (Java 21 can compile to Java 17 targets).

## Issues Fixed

### Issue 1: Java Version Not Found
```
Cannot find a Java installation on your machine matching this tasks requirements: {languageVersion=17}
No locally installed toolchains match and toolchain auto-provisioning is not enabled.
```

### Issue 2: SSL Certificate Errors (during auto-download)
```
javax.net.ssl.SSLHandshakeException: PKIX path building failed
```

## Solution: Configure Gradle to Use Your Java 21

We configure the project to:
1. **Target Java 17** (required by ultralytics_yolo)
2. **Use Java 21 JDK** to compile (backward compatible)
3. **Disable auto-download** to avoid SSL issues

## Setup Instructions (REQUIRED)

### Option 1: Configure gradle.properties (Recommended)

1. **Find your Java 21 installation path**

   Open PowerShell and run:
   ```powershell
   where java
   ```

   Common locations:
   - `C:\Program Files\Java\jdk-21`
   - `C:\Program Files\Microsoft\jdk-21.0.9.10-hotspot`
   - `C:\Program Files\OpenJDK\jdk-21`
   - `C:\Program Files\Eclipse Adoptium\jdk-21`

2. **Edit `wheel_inspector/android/gradle.properties`**

   Find this line (around line 8):
   ```properties
   # org.gradle.java.home=
   ```

   Uncomment it and set your Java path:
   ```properties
   org.gradle.java.home=C:\\Program Files\\Microsoft\\jdk-21.0.9.10-hotspot
   ```

   **IMPORTANT:** Use double backslashes `\\` in the path!

3. **Save and try building**
   ```bash
   cd wheel_inspector
   flutter build apk --release
   ```

### Option 2: Set JAVA_HOME Environment Variable

If you prefer system-wide configuration:

1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Go to "Advanced" tab → "Environment Variables"
3. Under "System variables", click "New"
   - **Variable name:** `JAVA_HOME`
   - **Variable value:** `C:\Program Files\Microsoft\jdk-21.0.9.10-hotspot` (your actual path)
4. Click OK
5. **Restart your terminal/PowerShell**
6. Verify:
   ```powershell
   echo $env:JAVA_HOME
   java -version
   ```

## Changes Applied to Project

### 1. Set Java 17 Target
**File:** `android/app/build.gradle`
- Kept `sourceCompatibility` and `targetCompatibility` as Java 17 (required by ultralytics_yolo)
- Kept `kotlinOptions.jvmTarget` as "17"

### 2. Added Gradle Java Home Configuration
**File:** `android/gradle.properties`
- Added `org.gradle.java.home` configuration placeholder
- You need to uncomment and set this to your Java 21 path

### 3. Disabled Auto-Download
**File:** `android/gradle.properties`
- Set `org.gradle.java.installations.auto-download=false` to avoid SSL errors
- Kept `org.gradle.java.installations.auto-detect=true` for backup detection

## Verification Steps

After configuring, verify your setup:

```powershell
# 1. Check Java version
java -version
# Should show: openjdk 21.0.9

# 2. Navigate to project
cd wheel_inspector

# 3. Clean previous build
flutter clean

# 4. Get dependencies
flutter pub get

# 5. Try building
flutter build apk --release
```

## Troubleshooting

### "Cannot find a Java installation"
- **Fix:** Set `org.gradle.java.home` in `android/gradle.properties` (see Option 1 above)
- Make sure you use double backslashes: `C:\\Program Files\\...`
- Remove any trailing backslash from the path

### "Could not find tools.jar"
- Make sure the path points to JDK (not JRE)
- The directory should contain: `bin/`, `lib/`, `include/`

### Still getting SSL errors
- Verify `org.gradle.java.installations.auto-download=false` in `gradle.properties`
- Make sure you've set `org.gradle.java.home` so Gradle doesn't try to download

### Path with spaces not working
- Always use double backslashes: `C:\\Program Files\\Java\\jdk-21`
- Don't use quotes in gradle.properties

## Example Configuration

Your `android/gradle.properties` should look like this:

```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true

# Java Configuration
# Set this to your Java 21 installation path with double backslashes
org.gradle.java.home=C:\\Program Files\\Microsoft\\jdk-21.0.9.10-hotspot

# Enable Java toolchain auto-detection
org.gradle.java.installations.auto-detect=true
org.gradle.java.installations.auto-download=false
```
