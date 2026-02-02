# Keep snakeyaml classes that reference java.beans (not available on Android)
-dontwarn java.beans.**
-dontwarn org.yaml.snakeyaml.**
-keep class org.yaml.snakeyaml.** { *; }

# Keep TFLite classes
-keep class org.tensorflow.lite.** { *; }
-keep class com.google.ai.edge.litert.** { *; }
-dontwarn org.tensorflow.lite.gpu.**
