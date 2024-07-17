### Quickstart developer guide

#### Prerequisites
  - Install Terraform 1.9.2
  - Service Account in GCP with Editor role (Consider using least privilege)
  - Create bucket in GCP for Terraform state
  - Enable GKE API
    - https://console.cloud.google.com/flows/enableapi?apiid=container.googleapis.com
  - Enable billing
    - `gcloud config set project`
    - `gcloud auth application-default login`
    - `gcloud beta billing projects describe project-name`
  - Push the dummy-png-pdf-microservice to artifact registry  

Since we need dummy -service in GCR; let's do it manually for now. Not something I'm proud of; but we're limited by time!
- `cd ../dummy-pdf-or-png`
- `docker buildx build --platform linux/amd64 -t europe-north1-docker.pkg.dev/sre-hiring-assignment/api-docker-registry/dummy-pdf-or-png:1.0 .`
- `gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://europe-north1-docker.pkg.dev`
- `docker push europe-north1-docker.pkg.dev/sre-hiring-assignment/api-docker-registry/dummy-pdf-or-png:1.0`

#### Development
- `gcloud config set project`
- `gcloud auth application-default login`
- `terraform init`
- `terraform plan -input=false -var-file=./cicd.tfvars`
- `terraform apply -input=false -var-file=./cicd.tfvars`

Point kubectl/k9s to the cluster:
- `gcloud container clusters get-credentials CLUSTER_NAME --region=COMPUTE_REGION`

#### Deployment
- Commit to sre/iac folder master branch, GitHub Actions will deploy it with Terraform
