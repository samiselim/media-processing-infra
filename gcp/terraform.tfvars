project_id          = "media-processing-465414"
region              = "us-central1"
zone                = "us-central1-a"
vpc_name            = "media-vpc"
private_subnet_cidr = "10.0.1.0/24"

db_username = "postgres"
db_password = "secure_password"

api_image              = "kennethreitz/httpbin"
frontend_image         = "nginxdemos/hello"
media_worker_image     = "busybox"
transcription_worker_image = "busybox"
ai_worker_image        = "busybox"
image_worker_image     = "busybox"
trim_worker_image      = "busybox"

api_port                  = 80
frontend_port             = 80
cloud_run_service_account = "media-sa@media-processing-465414.iam.gserviceaccount.com"