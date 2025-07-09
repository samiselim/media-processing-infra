# General Project Configuration
project     = "media-processing"
environment = "dev"
region      = "us-east-1"

# VPC Configuration
vpc_name           = "media-processing-vpc"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]

# RDS Configuration
db_username = "rds_username"
db_password = "rdspassword123"

# Security Groups
rds_sg_name        = "rds-sg"
rds_sg_description = "Allow PostgreSQL access"
rds_ingress_cidrs  = ["10.0.0.0/16"]

ecs_sg_name        = "ecs-sg"
ecs_sg_description = "Allow API access"
ecs_ingress_port   = 3000
ecs_ingress_cidrs  = ["0.0.0.0/0"]

alb_sg_name        = "alb-sg"
alb_sg_description = "Allow HTTP access"

# Container Images
# Basic frontend and backend (API)
api_image      = "nginxdemos/hello" # Simple demo API response
frontend_image = "nginxdemos/hello"

# Workers using minimal containers for testing
media_worker_image         = "busybox"         # Just runs and exits (simulate a worker)
transcription_worker_image = "alpine"          # Lightweight Linux distro for worker sim
ai_worker_image            = "python:3.9-slim" # Simulates AI worker
image_worker_image         = "alpine"          # Simulates image processing worker
trim_worker_image          = "busybox"         # Simulates media trimming worker
# ECS Task Settings
task_cpu    = "256"
task_memory = "512"

# Desired Count Per ECS Service
api_desired_count                  = 1
frontend_desired_count             = 1
media_worker_desired_count         = 0
transcription_worker_desired_count = 0
ai_worker_desired_count            = 0
image_worker_desired_count         = 0
trim_worker_desired_count          = 0
# Port Configuration
api_port      = 3000
frontend_port = 80
