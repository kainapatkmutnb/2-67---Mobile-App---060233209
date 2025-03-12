allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configure build directories
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()

rootProject.layout.buildDirectory.value(newBuildDir)

// Configure subprojects
subprojects {
    // Set build directory for each subproject
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Apply plugins based on project name
    if (project.name == "app") {
        project.plugins.apply("com.android.application")
    }
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}