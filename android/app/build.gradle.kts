plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "zhangsan.flutter_demo2"  // ← 必须是有效的包名，不能是空格或空
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "zhangsan.flutter_demo2"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            abiFilters.add("arm64-v8a")
        }
    }




    buildTypes {

        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.8.0")
    implementation("androidx.appcompat:appcompat:1.2.0")
    implementation("com.google.android.material:material:1.3.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("com.github.Alexxiaopang:KotlinKtx:1.2.0") {
        exclude(module = "rxlife-coroutine")
    }
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.4.2")
    implementation("com.alibaba:fastjson:1.1.72.android")
    implementation("com.blankj:utilcodex:1.30.6")
    api("com.github.getActivity:XXPermissions:16.0")

    // 本地 AAR/JAR 库（关键：双引号 + 正斜杠 /）

    // ... 前面远程依赖不变 ...
// 批量引入 libs 目录下所有 .aar 和 .jar（强烈推荐！）
    api(fileTree(mapOf("dir" to "libs", "include" to listOf("*.aar", "*.jar"))))


    api("com.gitee.wjiaqiao:product-kotlin:1.0.35")
    api("com.github.liangjingkanji:Serialize:1.3.1")
}