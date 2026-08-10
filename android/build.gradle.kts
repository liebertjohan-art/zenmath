allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    val configureAndroidExt = {
        val androidExt = project.extensions.findByName("android")
        if (androidExt != null) {
            try {
                val clazz = androidExt.javaClass
                try {
                    clazz.getMethod("compileSdkVersion", Int::class.java).invoke(androidExt, 34)
                } catch(e: Exception) {
                    clazz.getMethod("setCompileSdkVersion", Int::class.java).invoke(androidExt, 34)
                }
            } catch(e: Exception) {}

            try {
                val clazz = androidExt.javaClass
                if (clazz.getMethod("getNamespace").invoke(androidExt) == null) {
                    clazz.getMethod("setNamespace", String::class.java).invoke(androidExt, project.group.toString())
                }
            } catch(e: Exception) {}
        }
    }
    if (project.state.executed) {
        configureAndroidExt()
    } else {
        project.afterEvaluate { configureAndroidExt() }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
