# Java Configuration for Wheel Inspector

## Problem Summary

The `ultralytics_yolo` package requires Java 17, but Gradle cannot auto-detect your Java installation due to network/SSL restrictions. You have Java 17 installed, which is the exact version required.

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

## Solution: Configure Gradle to Use Your Java 17

We configure the project to:
1. **Target Java 17** (required by ultralytics_yolo)
2. **Use your installed Java 17 JDK** to compile
3. **Disable auto-download** to avoid SSL issues

## Setup Instructions (REQUIRED)

### Option 1: Configure gradle.properties (Recommended)

1. **Find your Java 17 installation path**

   Open PowerShell and run:
   ```powershell
   where java
   ```

   Common locations for Microsoft Java 17:
   - `C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot`
   - `C:\Program Files\Java\jdk-17`
   - `C:\Program Files\OpenJDK\jdk-17`
   - `C:\Program Files\Eclipse Adoptium\jdk-17`

   To find the exact JDK directory:
   ```powershell
   # Get the java.exe path
   where java
   # Output example: C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot\bin\java.exe
   # Your JDK path is: C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot
   ```

2. **Edit `wheel_inspector/android/gradle.properties`**

   Find line 12:
   ```properties
   org.gradle.java.home=
   ```

   Set your Java 17 path (remove the `#` if commented):
   ```properties
   org.gradle.java.home=C:\\Program Files\\Microsoft\\jdk-17.0.17.10-hotspot
   ```

   **IMPORTANT:**
   - Use double backslashes `\\` in the path!
   - Remove `\bin` from the path (should point to JDK root, not bin folder)
   - No trailing backslash

3. **Save and try building**
   ```bash
   cd wheel_inspector
   flutter clean
   flutter build apk --release
   ```

### Option 2: Set JAVA_HOME Environment Variable

If you prefer system-wide configuration:

1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Go to "Advanced" tab → "Environment Variables"
3. Under "System variables", click "New"
   - **Variable name:** `JAVA_HOME`
   - **Variable value:** `C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot` (your actual path)
4. Click OK
5. **Restart your terminal/PowerShell**
6. Verify:
   ```powershell
   echo $env:JAVA_HOME
   java -version
   # Should show: openjdk version "17.0.17"
   ```

## Changes Applied to Project

### 1. Set Java 17 Target
**File:** `android/app/build.gradle`
- Set `sourceCompatibility` and `targetCompatibility` to Java 17 (required by ultralytics_yolo)
- Set `kotlinOptions.jvmTarget` to "17"

### 2. Added Gradle Java Home Configuration
**File:** `android/gradle.properties`
- Added `org.gradle.java.home` configuration
- You need to set this to your Java 17 installation path

### 3. Disabled Auto-Download
**File:** `android/gradle.properties`
- Set `org.gradle.java.installations.auto-download=false` to avoid SSL errors
- Kept `org.gradle.java.installations.auto-detect=true` for backup detection

## Verification Steps

After configuring, verify your setup:

```powershell
# 1. Check Java version
java -version
# Should show: openjdk version "17.0.17"

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
- Path should point to JDK root (not the `bin` folder)

### "Could not find tools.jar"
- Make sure the path points to JDK (not JRE)
- The directory should contain: `bin/`, `lib/`, `include/`

### Still getting SSL errors
- Verify `org.gradle.java.installations.auto-download=false` in `gradle.properties`
- Make sure you've set `org.gradle.java.home` so Gradle doesn't try to download

### Path with spaces not working
- Always use double backslashes: `C:\\Program Files\\Java\\jdk-17`
- Don't use quotes in gradle.properties

### "Invalid Java path"
- Verify the path exists by running in PowerShell: `Test-Path "C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot"`
- Should return `True`
- Make sure there's no `\bin` at the end

## Example Configuration

Your `android/gradle.properties` should look like this:

```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true

# Java Configuration - REQUIRED FOR BUILD TO WORK
# Set this to your Java 17 installation path with double backslashes
org.gradle.java.home=C:\\Program Files\\Microsoft\\jdk-17.0.17.10-hotspot

# Enable Java toolchain auto-detection
org.gradle.java.installations.auto-detect=true
org.gradle.java.installations.auto-download=false
```

## Quick Fix Script

If you want to quickly test, run these commands in PowerShell:

```powershell
# Navigate to wheel_inspector folder
cd C:\Users\50014665\M-M\wheel_inspector

# Find Java path
$javaPath = (where.exe java) | Select-Object -First 1
$jdkPath = $javaPath -replace '\\bin\\java.exe$', ''
Write-Host "Java JDK Path: $jdkPath"

# Update gradle.properties programmatically (or edit manually)
$gradlePropsPath = "android\gradle.properties"
$gradlePropsPath = Resolve-Path $gradlePropsPath
$jdkPathEscaped = $jdkPath -replace '\\', '\\\\'
Write-Host "Set this in gradle.properties:"
Write-Host "org.gradle.java.home=$jdkPathEscaped"
```
