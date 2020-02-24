variable "cluster-name" {
  default = "websketch"
  type = string
}

variable "region" {
  default = "us-east-2"
  type = string
}

variable "sketch-repo-volume-size" {
  default = 10
  type = number
}

variable "logs-volume-size" {
  default = 2
  type = number
}

variable "db-volume-size" {
  default = 1
  type = number
}

variable "kustomize-output-path" {
  # Do not include closing slash:
  default = "."
  type = string
}