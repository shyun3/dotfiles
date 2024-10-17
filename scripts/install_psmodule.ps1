param ($module)

if (!(Get-Module $module)) {
    Install-Module $module -Repository PSGallery
}
