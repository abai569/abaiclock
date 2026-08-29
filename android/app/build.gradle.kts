import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val signingPropertiesFile = project.file("key.properties")
val signingProperties = Properties()
if (signingPropertiesFile.exists()) {
    signingProperties.load(FileInputStream(signingPropertiesFile))
}
val storeFilePath = signingProperties.getProperty("storeFile")
val storePasswordValue = signingProperties.getProperty("storePassword")
val keyAliasValue = signingProperties.getProperty("keyAlias")
val keyPasswordValue = signingProperties.getProperty("keyPassword")

android {
    namespace = "com.abaiclock.abaiclock"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.abaiclock.abaiclock"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            if (storeFilePath != null && storePasswordValue != null && keyAliasValue != null && keyPasswordValue != null) {
                signingConfig = signingConfigs.create("release") {
                    storeFile = project.file(storeFilePath)
                    storePassword = storePasswordValue
                    keyAlias = keyAliasValue
                    keyPassword = keyPasswordValue
                }
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}