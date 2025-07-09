# GCP Project Settings
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

# Networking
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR range for private subnet"
  type        = string
}

# Database
variable "db_username" {
  description = "PostgreSQL DB username"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL DB password"
  type        = string
  sensitive   = true
}

# Cloud Run / GKE Container Images
variable "api_image" {
  description = "Docker image for API service"
  type        = string
}

variable "frontend_image" {
  description = "Docker image for Frontend"
  type        = string
}

variable "media_worker_image" {
  description = "Docker image for Media Worker"
  type        = string
}

variable "transcription_worker_image" {
  description = "Docker image for Transcription Worker"
  type        = string
}

variable "ai_worker_image" {
  description = "Docker image for AI Worker"
  type        = string
}

variable "image_worker_image" {
  description = "Docker image for Image Worker"
  type        = string
}

variable "trim_worker_image" {
  description = "Docker image for Trim Worker"
  type        = string
}

# Ports
variable "api_port" {
  description = "API container port"
  type        = number
}

variable "frontend_port" {
  description = "Frontend container port"
  type        = number
}
variable "cloud_run_service_account" {
  description = "Service account used by Cloud Run services"
  type        = string
}
