
variable "first_peer_network_name" {
  description = "The name of the first network which is ready to peer"
}

variable "second_peer_network_name" {
  description = "The name of the second network which is ready to peer"
}

variable "first_network_id" {
  description = "The id of the first network which is ready to peer"
}

variable "second_network_id" {
  description = "The id of the second network which is ready to peer"
}

variable "export_custom_routes" {
  description = "Whether to export the custom routes to the peer network. Defaults to false"
}

variable "import_custom_routes" {
  description = "Whether to import the custom routes to the peer network. Defaults to false"
}