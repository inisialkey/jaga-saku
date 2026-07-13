pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // Toolchain floors required by Flutter 3.44.x (below these, `flutter run`
    // warns the versions "will soon be dropped"): AGP >= 8.11.1, Kotlin >=
    // 2.2.20, Gradle >= 8.14 (wrapper). AGP 8.11.1 needs Gradle >= 8.13, so the
    // wrapper was bumped 8.12 -> 8.14 in lockstep. image_picker (V2-M4) still
    // pins the compileSdk 36 / AAR-metadata floor these clear.
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")