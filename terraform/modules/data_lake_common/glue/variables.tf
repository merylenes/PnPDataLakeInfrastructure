variable "name" {
  description = "Refers to the lake, or project name.  Ex. 'sap_bw'."
  type        = string
  default     = ""
}

variable "functional_zone_ingestion" {
  type    = any
  default = []
}

variable "functional_zone_store" {
  default = []
}

variable "short_environment" { type = string }

variable "role" {
  description = "The role used by Gle to access the data stores and catalogue."
}
