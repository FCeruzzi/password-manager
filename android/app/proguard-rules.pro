# Flutter/R8 rules for release build
# Suppress warnings for logging libraries not available on Android
-dontwarn ch.qos.logback.classic.**
-dontwarn dalvik.system.VMStack
-dontwarn java.lang.ProcessHandle
-dontwarn java.lang.management.**
-dontwarn javax.naming.**
-dontwarn sun.reflect.Reflection
