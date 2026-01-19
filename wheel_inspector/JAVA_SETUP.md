# Java 21 Configuration for Wheel Inspector

## Issues Encountered

### Issue 1: Java Version Mismatch
```
Cannot find a Java installation on your machine matching this tasks requirements: {languageVersion=17, vendor=any, implementation=vendor-specific}
```
**Solution:** Updated project to use Java 21 (which you have installed)

### Issue 2: SSL Certificate Error
```
javax.net.ssl.SSLHandshakeException: PKIX path building failed:
sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
```
**Solution:** Disabled auto-download to use your local Java 21 installation instead

## Changes Applied

### 1. Updated Java Version to 21
**File:** `android/app/build.gradle`
- Changed `sourceCompatibility` and `targetCompatibility` from Java 17 to Java 21
- Updated `kotlinOptions.jvmTarget` to "21"

### 2. Configured Gradle for Local Java
**File:** `android/gradle.properties`
- Enabled `org.gradle.java.installations.auto-detect=true` - finds locally installed Java
- Set `org.gradle.java.installations.auto-download=false` - prevents SSL issues

### 3. Removed Foojay Plugin
**File:** `android/settings.gradle`
- Removed the Foojay resolver plugin (not needed since we use local Java)

## Setting up JAVA_HOME (IMPORTANT)

For Gradle to find your Java 21 installation, you **must** set the `JAVA_HOME` environment variable:

### Step 1: Find Your Java Installation
Common locations:
- `C:\Program Files\Java\jdk-21`
- `C:\Program Files\OpenJDK\jdk-21`
- `C:\Program Files\Eclipse Adoptium\jdk-21`

### Step 2: Set JAVA_HOME on Windows

1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Go to "Advanced" tab → Click "Environment Variables"
3. Under "System variables", click "New"
4. **Variable name:** `JAVA_HOME`
5. **Variable value:** Your JDK 21 path (e.g., `C:\Program Files\Java\jdk-21`)
6. Click OK

### Step 3: Add to PATH

1. In "System variables", find and select "Path"
2. Click "Edit"
3. Click "New"
4. Add: `%JAVA_HOME%\bin`
5. Click OK on all windows

### Step 4: Verify Installation

Open a **NEW** terminal/PowerShell window and run:

```powershell
# Check JAVA_HOME
echo $env:JAVA_HOME

# Check Java version
java -version

# Check Gradle can find it
cd wheel_inspector
.\gradlew.bat --version
```

## Alternative: Quick Test Without Setting JAVA_HOME

If you don't want to set environment variables permanently, you can test with:

```powershell
$env:JAVA_HOME="C:\Program Files\Java\jdk-21"  # Adjust path
cd wheel_inspector
flutter build apk --release
```

## Troubleshooting

### "Could not find tools.jar"
- Make sure `JAVA_HOME` points to the JDK, not JRE
- The path should contain folders like `bin`, `lib`, `include`

### Still getting SSL errors
- Make sure `auto-download=false` in `android/gradle.properties`
- Clear Gradle cache: `.\gradlew.bat clean`

### "Gradle cannot find Java"
1. Verify `JAVA_HOME` is set correctly
2. Restart your terminal
3. Run `java -version` to confirm Java 21 is accessible

## Next Steps

After setting `JAVA_HOME`, try building:
```bash
cd wheel_inspector
flutter build apk --release
```
