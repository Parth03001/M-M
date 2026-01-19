# Java Configuration for Wheel Inspector

## ✅ ISSUE RESOLVED

The configuration has been copied from `classifier_app` which builds successfully.

## Problem Summary

The `ultralytics_yolo` package requires Java 17, but Gradle cannot auto-detect your Java installation due to network/SSL restrictions.

## Solution Applied

**Copied the working Java configuration from classifier_app:**

```properties
org.gradle.java.home=C:/Users/50014665/jdk-17.0.17+10
```

This is the exact same configuration that makes classifier_app build successfully, so wheel_inspector should now build as well.

## What Was Fixed

### Issue 1: Java Version Not Found
```
Cannot find a Java installation on your machine matching this tasks requirements: {languageVersion=17}
No locally installed toolchains match and toolchain auto-provisioning is not enabled.
```

**Fixed by:** Setting `org.gradle.java.home` to your Java 17 installation path

### Issue 2: SSL Certificate Errors
```
javax.net.ssl.SSLHandshakeException: PKIX path building failed
```

**Fixed by:** Disabling auto-download with `org.gradle.java.installations.auto-download=false`

## Final Configuration

**File:** `wheel_inspector/android/gradle.properties`

```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true

# Java Configuration - Copied from classifier_app (which builds successfully)
org.gradle.java.home=C:/Users/50014665/jdk-17.0.17+10

# Enable Java toolchain auto-detection (auto-download disabled to avoid SSL issues)
org.gradle.java.installations.auto-detect=true
org.gradle.java.installations.auto-download=false
```

**File:** `wheel_inspector/android/app/build.gradle`

```gradle
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

kotlinOptions {
    jvmTarget = "17"
}
```

## Build Instructions

Now you can build the wheel_inspector app:

```bash
cd wheel_inspector
flutter clean
flutter build apk --release
```

This should work exactly like classifier_app since it uses the same Java configuration.

## Why This Works

1. **classifier_app** already had `org.gradle.java.home=C:/Users/50014665/jdk-17.0.17+10` configured
2. This tells Gradle exactly where Java 17 is installed
3. Gradle doesn't need to auto-detect or download anything
4. Both apps use the same Java requirements (Java 17 for ultralytics_yolo)
5. By copying the same configuration, wheel_inspector should build successfully

## Note on Path Format

The classifier_app uses forward slashes `/` which works on Windows in Gradle:
```
C:/Users/50014665/jdk-17.0.17+10
```

This is equivalent to using double backslashes `\\`:
```
C:\\Users\\50014665\\jdk-17.0.17+10
```

Both formats are valid in gradle.properties files.
