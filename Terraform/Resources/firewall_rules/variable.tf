
variable "firewall_name" {
  description = "Name of the Firewall rule"
}

variable "network_id" {
  description = "The id of the network to attach this firewall to"
}

variable "source_ranges" {
  type        = "list"
  description = "A list of source CIDR ranges that this firewall applies to. Can't be used for EGRESS"
}

variable "target_tags" {
  type = "list"
  description = "A list of target tags for this firewall"
}

variable "source_tags" {
  type  = "list"
  description = "A list of source tags for this firewall"
}

variable "protocol" {
  description = "The name of the protocol to allow. This value can either be one of the following well known protocol strings (tcp, udp, icmp, esp, ah, sctp), or the IP protocol number, or all"
}

variable "ports" {
  type = list(string)
  description = "List of ports and/or port ranges to allow. This can only be specified if the protocol is TCP or UDP"
  default = []
}

variable "direction" {
  description = "Direction of traffic to which this firewall applies; default is INGRESS. Note: For INGRESS traffic, it is NOT supported to specify destinationRanges; For EGRESS traffic, it is NOT supported to specify sourceRanges OR sourceTags. Possible values are INGRESS and EGRESS."
  default = ""
}

variable "project_id" {
    description = "The host project ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "logging_enable" {
    description = "Set it as false, if you don't want to send logs to stackdriver"
    default = true
}

variable "udp_ports" {
    description = "UDP Ports Information"
    type = list(string)
     default = []
}

variable "http_ports" {
    description = "UDP Ports Information"
    type = list(string)
     default = []
}

variable "https_ports" {
    description = "UDP Ports Information"
    type = list(string)
     default = []
}