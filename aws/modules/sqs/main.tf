resource "aws_sqs_queue" "job_queue" {
  name = "${var.project}-job-queue"
}
