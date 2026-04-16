plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.foodgram"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true         
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.moviles.foodgram"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true                         
    }

    buildTypes {
        release {
            isMinifyEnabled = false 
            isShrinkResources = false
        
        // Para signingConfig en KTS se accede así:
        signingConfig = signingConfigs.getByName("debug")

        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")  
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}