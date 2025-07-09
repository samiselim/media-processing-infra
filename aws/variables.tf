# variables.tf for Root Module

variable "region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}

variable "rds_sg_name" {
  description = "Name of the RDS security group"
  type        = string
}

variable "rds_sg_description" {
  description = "Description for the RDS security group"
  type        = string
}

variable "rds_ingress_cidrs" {
  description = "Allowed CIDRs for RDS ingress"
  type        = list(string)
}

variable "ecs_sg_name" {
  description = "Name of the ECS security group"
  type        = string
}

variable "ecs_sg_description" {
  description = "Description for the ECS security group"
  type        = string
}

variable "ecs_ingress_port" {
  description = "Ingress port for ECS services"
  type        = number
}

variable "ecs_ingress_cidrs" {
  description = "Allowed CIDRs for ECS ingress"
  type        = list(string)
}

variable "alb_sg_name" {
  description = "Name of the ALB security group"
  type        = string
}

variable "alb_sg_description" {
  description = "Description for the ALB security group"
  type        = string
}

variable "api_image" {
  description = "Docker image for the API service"
  type        = string
}

variable "frontend_image" {
  description = "Docker image for the frontend"
  type        = string
}

variable "media_worker_image" {
  description = "Docker image for media worker"
  type        = string
}

variable "transcription_worker_image" {
  description = "Docker image for transcription worker"
  type        = string
}

variable "ai_worker_image" {
  description = "Docker image for AI worker"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for ECS tasks"
  type        = string
}

variable "task_memory" {
  description = "Memory for ECS tasks"
  type        = string
}

variable "api_desired_count" {
  description = "Desired count for API service"
  type        = number
}

variable "frontend_desired_count" {
  description = "Desired count for frontend"
  type        = number
}

variable "media_worker_desired_count" {
  description = "Desired count for media worker"
  type        = number
}

variable "transcription_worker_desired_count" {
  description = "Desired count for transcription worker"
  type        = number
}

variable "ai_worker_desired_count" {
  description = "Desired count for AI worker"
  type        = number
}

variable "trim_worker_image" {
  description = "Desired count for AI worker"
  type        = string
}

variable "image_worker_image" {
  description = "Desired count for AI worker"
  type        = string
}


variable "api_port" {
  description = "Port used by API container"
  type        = number
}

variable "frontend_port" {
  description = "Port used by frontend container"
  type        = number
}
variable "image_worker_desired_count" {
  description = "Desired count of ECS tasks for the Image Worker"
  type        = number
  default     = 1
}


variable "trim_worker_desired_count" {
  description = "Desired count of ECS tasks for the Trim Worker"
  type        = number
  default     = 1
}
