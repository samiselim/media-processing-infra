variable "project" {}
variable "environment" {}
variable "db_username" {}
variable "db_password" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
