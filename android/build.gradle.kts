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
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    afterEvaluate {
        val androidExt = project.extensions.findByName("android")
        if (androidExt != null) {
            try {
                val clazz = androidExt.javaClass
                val getNamespace = clazz.getMethod("getNamespace")
                val namespace = getNamespace.invoke(androidExt)
                if (namespace == null) {
                    val setNamespace = clazz.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(androidExt, project.group.toString())
                }
            } catch (e: Exception) {
                // Ignore
            }
        }
    }
}
