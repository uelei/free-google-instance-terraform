variable "ssh_user" {
  type        = string
  description = "SSH user for compute instance"
  default     = "uelei"
  sensitive   = false
}

variable project {
  type = string
  default = "uelei-cloud"

}


variable region {
  type = string
  default = "us-east1"

}


variable zone {
  type = string
  default = "us-east1-b"

}
