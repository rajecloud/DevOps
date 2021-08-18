# Creating a Folders for the Projects usecase.

resource "google_folder" "parent_folders" {
  for_each = toset(var.names)
  display_name = each.value
  parent       = organizations/var.organization_id
}

resource "google_folder" "sub_folders" {
  for_each = toset(var.names)
  display_name = each.value
  parent       = folders/var.parent_folder_id
}

