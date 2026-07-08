import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val localProperties = Properties().apply {
    val file = rootProject.file("local.properties")
    if (file.exists()) {
        file.reader(Charsets.UTF_8).use { load(it) }
    }
}
val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.consteon.jagasaku"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        // Required by flutter_local_notifications (uses java.time APIs on minSdk < 26).
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDir("src/main/kotlin")
        }
    }

    lint {
        disable += "InvalidPackage"
    }

    defaultConfig {
        applicationId = "com.consteon.jagasaku"
        minSdk = 25
        targetSdk = 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
    }

    signingConfigs {
        getByName("debug") {
            // opsional: biarkan kosong, atau setel jika memang ingin override
            // storeFile = file("debug.keystore")
            // storePassword = "android"
            // keyAlias = "androiddebugkey"
            // keyPassword = "android"
        }
        create("release") {
            // Resolve signing material from env first, then android/key.properties.
            val keyProps = Properties()
            val keyPropsFile = rootProject.file("key.properties")
            if (keyPropsFile.exists()) {
                keyPropsFile.inputStream().use { keyProps.load(it) }
            }

            val resolvedStoreFile =
                System.getenv("MYAPP_RELEASE_STORE_FILE") ?: keyProps.getProperty("storeFile")
            val resolvedStorePassword =
                System.getenv("MYAPP_RELEASE_STORE_PASSWORD") ?: keyProps.getProperty("storePassword")
            val resolvedKeyAlias =
                System.getenv("MYAPP_RELEASE_KEY_ALIAS") ?: keyProps.getProperty("keyAlias")
            val resolvedKeyPassword =
                System.getenv("MYAPP_RELEASE_KEY_PASSWORD") ?: keyProps.getProperty("keyPassword")

            // Hard-fail only when actually assembling a stg/prd release artifact.
            // dev (internal testing) and non-release tasks keep falling back to the debug keystore.
            val buildingStgOrPrdRelease = gradle.startParameter.taskNames.any { task ->
                val t = task.lowercase()
                (t.contains("stg") || t.contains("prd")) && t.contains("release")
            }

            if (resolvedStoreFile.isNullOrBlank()) {
                if (buildingStgOrPrdRelease) {
                    throw GradleException(
                        "Release signing key missing for stg/prd build. Set MYAPP_RELEASE_STORE_FILE " +
                            "(+ STORE_PASSWORD/KEY_ALIAS/KEY_PASSWORD) or provide android/key.properties."
                    )
                }
                logger.warn("WARNING: Release signing uses debug keystore (dev flavor or non-release task).")
            }

            storeFile = file(resolvedStoreFile ?: "debug.keystore")
            storePassword = resolvedStorePassword ?: "android"
            keyAlias = resolvedKeyAlias ?: "androiddebugkey"
            keyPassword = resolvedKeyPassword ?: "android"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Jaga Saku DEV")
            signingConfig = signingConfigs.getByName("release")
        }
        create("stg") {
            dimension = "env"
            applicationIdSuffix = ".stg"
            resValue("string", "app_name", "Jaga Saku STG")
            signingConfig = signingConfigs.getByName("release")
        }
        create("prd") {
            dimension = "env"
            resValue("string", "app_name", "Jaga Saku")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.0")
    implementation(enforcedPlatform("com.google.firebase:firebase-bom:33.5.1"))
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("com.google.firebase:firebase-analytics-ktx")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
