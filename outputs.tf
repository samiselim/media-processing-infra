output "vpc_id" {
  value = module.vpc.vpc_id
}
output "alb_dns_name" {
  value = module.cloudfront_alb.alb_dns
}
output "cloudfront_url" {
  value = module.cloudfront_alb.cloudfront_domain_name
}