variable "project" {}
variable "region" {}

variable "api_image" {}
variable "frontend_image" {}
variable "media_worker_image" {}
variable "transcription_worker_image" {}
variable "ai_worker_image" {}

variable "sqs_queue_url" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
variable "frontend_target_group_arn" {}

variable "task_cpu" {}
variable "task_memory" {}

variable "api_desired_count" {}
variable "frontend_desired_count" {}
variable "media_worker_desired_count" {}
variable "transcription_worker_desired_count" {}
variable "ai_worker_desired_count" {}

variable "api_port" {}
variable "frontend_port" {}
variable "image_worker_image" {
  description = "Container image for the Image Worker"
  type        = string
}

variable "image_worker_desired_count" {
  description = "Desired count of ECS tasks for the Image Worker"
  type        = number
  default     = 1
}

variable "trim_worker_image" {
  description = "Container image for the Trim Worker"
  type        = string
}

variable "trim_worker_desired_count" {
  description = "Desired count of ECS tasks for the Trim Worker"
  type        = number
  default     = 1
}
