
# Creating Sub Folders under the Parent Folders for the Projects usecase.

data "google_folder" "parent_folder" {
  folder              = var.parent_folder
  lookup_organization = var.org_lookup
}

resource "google_folder" "folder" {
  display_name = var.folder_name
  parent       = data.google_folder.area_folder.name
}

