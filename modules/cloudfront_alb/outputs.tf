output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "alb_dns" {
  value = aws_lb.frontend_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.frontend_tg.arn
}
