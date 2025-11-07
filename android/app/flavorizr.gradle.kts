import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("development") {
            dimension = "flavor-type"
            applicationId = "com.sqa.programgenie.dev"
            resValue(type = "string", name = "app_name", value = "Program Genie Dev")
        }
        create("production") {
            dimension = "flavor-type"
            applicationId = "com.sqa.programgenie"
            resValue(type = "string", name = "app_name", value = "Program Genie")
        }
    }
}