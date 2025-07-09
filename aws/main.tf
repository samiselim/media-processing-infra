
module "vpc" {
  source          = "./modules/vpc"
  name            = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  environment     = var.environment
  project         = var.project
}

module "s3" {
  source  = "./modules/s3"
  project = var.project
}

module "sqs" {
  source  = "./modules/sqs"
  project = var.project
}

resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg_name
  description = var.rds_sg_description
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.rds_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "rds" {
  source            = "./modules/rds"
  project           = var.project
  environment       = var.environment
  db_username       = var.db_username
  db_password       = var.db_password
  subnet_ids        = module.vpc.private_subnets
  security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group" "ecs_sg" {
  name        = var.ecs_sg_name
  description = var.ecs_sg_description
  vpc_id      = module.vpc.vpc_id

  ## this for alb
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    from_port   = var.ecs_ingress_port
    to_port     = var.ecs_ingress_port
    protocol    = "tcp"
    cidr_blocks = var.ecs_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = var.alb_sg_description
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "cloudfront_alb" {
  source            = "./modules/cloudfront_alb"
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnets
  security_group_id = aws_security_group.alb_sg.id
}

module "ecs" {
  source                             = "./modules/ecs"
  project                            = var.project
  region                             = var.region
  api_image                          = var.api_image
  frontend_image                     = var.frontend_image
  media_worker_image                 = var.media_worker_image
  transcription_worker_image         = var.transcription_worker_image
  ai_worker_image                    = var.ai_worker_image
  image_worker_image                 = var.image_worker_image
  trim_worker_image                  = var.trim_worker_image
  sqs_queue_url                      = module.sqs.job_queue_url
  subnet_ids                         = module.vpc.private_subnets
  security_group_id                  = aws_security_group.ecs_sg.id
  frontend_target_group_arn          = module.cloudfront_alb.target_group_arn
  task_cpu                           = var.task_cpu
  task_memory                        = var.task_memory
  api_desired_count                  = var.api_desired_count
  frontend_desired_count             = var.frontend_desired_count
  media_worker_desired_count         = var.media_worker_desired_count
  transcription_worker_desired_count = var.transcription_worker_desired_count
  ai_worker_desired_count            = var.ai_worker_desired_count
  image_worker_desired_count         = var.image_worker_desired_count
  trim_worker_desired_count          = var.trim_worker_desired_count
  api_port                           = var.api_port
  frontend_port                      = var.frontend_port
}

module "api_gateway" {
  source       = "./modules/api_gateway"
  project      = var.project
  api_endpoint = "http://${module.cloudfront_alb.alb_dns}"
}

# Auto Scaling Targets
resource "aws_appautoscaling_target" "media_worker_target" {
  max_capacity       = 5
  min_capacity       = 0
  resource_id        = "service/${module.ecs.ecs_cluster_id}/${module.ecs.media_worker_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_target" "transcription_worker_target" {
  max_capacity       = 5
  min_capacity       = 0
  resource_id        = "service/${module.ecs.ecs_cluster_id}/${module.ecs.transcription_worker_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_target" "ai_worker_target" {
  max_capacity       = 5
  min_capacity       = 0
  resource_id        = "service/${module.ecs.ecs_cluster_id}/${module.ecs.ai_worker_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Scale-In Policies
resource "aws_appautoscaling_policy" "scale_in_media_worker" {
  name               = "scale-in-media-worker"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.media_worker_target.resource_id
  scalable_dimension = aws_appautoscaling_target.media_worker_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.media_worker_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in_transcription_worker" {
  name               = "scale-in-transcription-worker"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.transcription_worker_target.resource_id
  scalable_dimension = aws_appautoscaling_target.transcription_worker_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.transcription_worker_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in_ai_worker" {
  name               = "scale-in-ai-worker"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ai_worker_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ai_worker_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ai_worker_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# Metric Alarms for scale-in
resource "aws_cloudwatch_metric_alarm" "scale_in_media_worker" {
  alarm_name          = "media-worker-sqs-depth-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  dimensions = {
    QueueName = module.sqs.queue_name
  }
  alarm_actions = [aws_appautoscaling_policy.scale_in_media_worker.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_in_transcription_worker" {
  alarm_name          = "transcription-worker-sqs-depth-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  dimensions = {
    QueueName = module.sqs.queue_name
  }
  alarm_actions = [aws_appautoscaling_policy.scale_in_transcription_worker.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_in_ai_worker" {
  alarm_name          = "ai-worker-sqs-depth-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  dimensions = {
    QueueName = module.sqs.queue_name
  }
  alarm_actions = [aws_appautoscaling_policy.scale_in_ai_worker.arn]
}

# ================= MODULE: ECS outputs.tf (optional) =================
# Remove any output related to autoscaling target if you use root autoscaling blocks

# ================= MODULE: ECS autoscaling targets =================
# You do NOT need to define aws_appautoscaling_target inside the ECS module
# Keep all autoscaling in main root for clarity and control
