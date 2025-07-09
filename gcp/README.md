# Media Processing Infrastructure on Google Cloud (GCP)

## 📦 Overview

This project deploys a media processing infrastructure on GCP using Terraform. It includes:

- **Cloud Run Services**:
  - `frontend-service`
  - `api-service`
  - `ai-worker`
  - `media-worker`
  - `transcription-worker`
  - `trim-worker`
  - `image-worker`

- **Cloud SQL**: PostgreSQL database named `media-db`

- **Other Components**:
  - IAM service accounts
  - Pub/Sub (optional for queueing)
  - Load balancer (if needed)
  - Monitoring alerts
  - GCS buckets (optional)

---

## 🛠️ Deployment Steps

1. **Set up GCP CLI**:
   ```bash
   gcloud init
   gcloud auth application-default login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **Create a Terraform backend (optional)**

3. **Deploy Terraform**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Enable necessary APIs**:
   Ensure the following GCP services are enabled:
   - Cloud Run
   - Cloud SQL Admin
   - IAM
   - Compute Engine
   - Logging & Monitoring

---

## 🔧 Configuration Variables

| Variable Name             | Description                                |
|---------------------------|--------------------------------------------|
| `region`                  | GCP region (e.g., `us-central1`)           |
| `media_worker_image`      | Container image for media-worker           |
| `transcription_worker_image` | Container image for transcription-worker |
| `ai_worker_image`         | Container image for ai-worker              |
| `image_worker_image`      | Container image for image-worker           |
| `trim_worker_image`       | Container image for trim-worker            |
| `api_service_image`       | Container image for API service            |
| `frontend_service_image`  | Container image for frontend               |

---

## 🚀 Service Testing

- After deployment, each Cloud Run service will have a public HTTPS URL.
- Example:
  ```bash
  curl https://api-service-XXXXXX-uc.a.run.app
  ```
- If using `busybox`, default response may show root filesystem directory listing — you can customize the entrypoint or command for real responses.

---

## 🧪 Validation Checklist

- [x] All services return HTTP 200 or expected response
- [x] Cloud SQL database created and accessible
- [x] IAM permissions validated
- [x] DNS or custom domain (optional)
- [x] Cloud Monitoring alerting policies configured (if enabled)

---

## 🐛 Troubleshooting

- **SSL Errors**: Use full domain name from GCP and avoid short links
- **Cloud Run container fails to start**: Check logs under:
  https://console.cloud.google.com/run
- **Health check issues**: Cloud Run with serverless NEG does not support traditional health checks

---

## 📂 Project Structure

```
├── main.tf
├── cloudrun.tf
├── sql.tf
├── variables.tf
├── loadbalancer.tf (optional)
└── outputs.tf
```

---

## 👥 Contributors

- Sami Selim

---

## 📄 License

This project is intended for internal usage and prototyping. Please contact the author for production licensing details.