output "job_queue_url" {
  value = aws_sqs_queue.job_queue.id
}
output "queue_name" {
  value = aws_sqs_queue.job_queue.name
}
