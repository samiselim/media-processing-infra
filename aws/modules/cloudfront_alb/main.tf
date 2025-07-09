resource "aws_lb" "frontend_alb" {
  name               = "${var.project}-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "frontend_tg" {
  name        = "${var.project}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"                # This should respond with HTTP 200
    port                = "traffic-port"     # Uses ECS task port (80)
    protocol            = "HTTP"
    matcher             = "200"              # Expect HTTP 200
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_lb.frontend_alb.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Project = var.project
  }
}
resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${var.project}-api"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.project}-frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "media_worker" {
  name              = "/ecs/${var.project}-media-worker"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "transcription_worker" {
  name              = "/ecs/${var.project}-transcription-worker"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ai_worker" {
  name              = "/ecs/${var.project}-ai-worker"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "image_worker" {
  name              = "/ecs/${var.project}-image-worker"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "trim_worker" {
  name              = "/ecs/${var.project}-trim-worker"
  retention_in_days = 7
}
