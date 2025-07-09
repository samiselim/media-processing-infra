output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "api_service_name" {
  value = aws_ecs_service.api.name
}

output "frontend_service_name" {
  value = aws_ecs_service.frontend.name
}

output "media_worker_service_name" {
  value = aws_ecs_service.media_worker.name
}

output "transcription_worker_service_name" {
  value = aws_ecs_service.transcription_worker.name
}

output "ai_worker_service_name" {
  value = aws_ecs_service.ai_worker.name
}