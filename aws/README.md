# 📦 Media Processing Microservices Infrastructure (Terraform)

This project provisions a scalable AWS infrastructure using **Terraform** to run multiple containerized microservices on **ECS Fargate**, with a frontend, API, and background worker tasks for media processing.

---

## 📐 Architecture Overview

The infrastructure includes:

- **VPC** with public/private subnets across multiple AZs
- **ECS Cluster** running:
  - `frontend` (nginx demo UI)
  - `api` (nginx demo API)
  - Worker services: `media`, `transcription`, `ai`, `image`, and `trim`
- **Application Load Balancer (ALB)** with **CloudFront** CDN
- **SQS** queue for distributing jobs to workers
- **RDS** PostgreSQL DB (optional)
- **API Gateway** to expose services via HTTP Proxy
- **CloudWatch Logs** for all containers
- **Auto Scaling** policies for worker services based on SQS depth

---

## 📁 Project Structure

```
.
├── main.tf                  # Root Terraform config
├── modules/
│   ├── vpc/                 # VPC, subnets, route tables
│   ├── s3/                  # Optional S3 bucket
│   ├── sqs/                 # Job queue
│   ├── rds/                 # PostgreSQL RDS (optional)
│   ├── ecs/                 # ECS cluster, task defs, services
│   ├── cloudfront_alb/      # CloudFront + ALB + target group
│   ├── api_gateway/         # API Gateway proxy to ALB
├── variables.tf
└── outputs.tf
```

---

## 🛠 Services Deployed

| Service | Image | Purpose |
|--------|--------|---------|
| `frontend` | `nginxdemos/hello` | UI served via ALB & CloudFront |
| `api` | `nginxdemos/hello` | Simulated backend API |
| `media_worker` | `busybox` | Simulates background processing |
| `transcription_worker` | `alpine` | Simulates transcription logic |
| `ai_worker` | `python:3.9-slim` | Simulates AI analysis |
| `image_worker` | `alpine` | Simulates image jobs |
| `trim_worker` | `busybox` | Simulates video trimming |

---

## ⚙️ Inputs

Customize the following variables in your `terraform.tfvars` or `variables.tf`:

```hcl
project                 = "media-processing"
region                  = "us-east-1"
vpc_cidr                = "10.0.0.0/16"
public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets         = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones      = ["us-east-1a", "us-east-1b"]

api_image               = "nginxdemos/hello"
frontend_image          = "nginxdemos/hello"
media_worker_image      = "busybox"
transcription_worker_image = "alpine"
ai_worker_image         = "python:3.9-slim"
image_worker_image      = "alpine"
trim_worker_image       = "busybox"

task_cpu                = "256"
task_memory             = "512"
api_port                = 80
frontend_port           = 80

api_desired_count       = 1
frontend_desired_count  = 1
media_worker_desired_count = 1
transcription_worker_desired_count = 1
ai_worker_desired_count = 1
image_worker_desired_count = 1
trim_worker_desired_count = 1
```

---

## 🚀 Deploy Instructions

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review Plan

```bash
terraform plan
```

### 3. Apply Infrastructure

```bash
terraform apply
```

---

## 📡 Accessing the Application

Once deployed, access the app via:

- **CloudFront URL** → frontend UI
- **API Gateway endpoint** → proxied API calls
- **ALB DNS** (optional) → directly to frontend or API

---

## 🔄 Auto Scaling

Worker services scale in based on **SQS queue depth** using CloudWatch alarms:

- If queue depth `< 1` for 2 minutes → scale **in**
- (Optional: Add scale-out logic if depth > 10, etc.)

---

## 📊 Monitoring & Logs

- **CloudWatch Logs**: All container logs go to `/ecs/{service-name}`
- **CloudWatch Alarms**: Trigger scale-in for workers
- **Target Group Health**: Checked via HTTP 200 on `/`

---

## 🧪 Testing

To test scaling behavior:

1. Push jobs to SQS manually.
2. Observe workers scaling in/out in ECS console.
3. Check logs via CloudWatch Logs.

---

## 🧹 Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

---

## 📌 Notes

- Ensure IAM roles have `AmazonECSTaskExecutionRolePolicy` attached.
- CloudWatch log groups must be pre-created or created via Terraform.
- ECS services use `awsvpc` mode and run in private subnets.
- ALB uses `target_type = "ip"` to register Fargate tasks.

---

## 📧 Contact

For questions or suggestions, feel free to open an issue or reach out to the DevOps team.
