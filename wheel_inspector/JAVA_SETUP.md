# Java 21 Configuration for Wheel Inspector

## Problem
The build was failing with this error:
```
Cannot find a Java installation on your machine matching this tasks requirements: {languageVersion=17, vendor=any, implementation=vendor-specific}
```

The project was configured for Java 17, but you have Java 21 installed on your system.

## Solution Applied

Since you have Java 21 installed (which is newer and fully compatible), I've updated the project to use Java 21 instead:

### 1. Updated Java Version
**File:** `android/app/build.gradle`
- Changed `sourceCompatibility` and `targetCompatibility` from Java 17 to Java 21
- Updated `kotlinOptions.jvmTarget` to "21"

### 2. Added Gradle Toolchain Configuration
**File:** `android/settings.gradle`
- Added `org.gradle.toolchains.foojay-resolver-convention` plugin
- Enables automatic JDK detection

**File:** `android/gradle.properties`
- Added `org.gradle.java.installations.auto-detect=true`
- Added `org.gradle.java.installations.auto-download=true`

## Verify Java Installation

Make sure your `JAVA_HOME` environment variable points to Java 21:

### Windows (PowerShell)
```powershell
echo $env:JAVA_HOME
java -version
```

### Windows (Command Prompt)
```cmd
echo %JAVA_HOME%
java -version
```

The output should show Java 21.x.x

## If JAVA_HOME is Not Set

If Gradle still can't find Java 21, set the `JAVA_HOME` environment variable:

### Windows
1. Search for "Environment Variables" in Windows search
2. Click "Environment Variables" button
3. Under "System variables", click "New"
4. Variable name: `JAVA_HOME`
5. Variable value: Path to your JDK 21 (e.g., `C:\Program Files\Java\jdk-21`)
6. Click OK
7. Restart your terminal/PowerShell

## Next Steps

Try building again:
```bash
cd wheel_inspector
flutter build apk --release
```

The build should now work with your Java 21 installation!
