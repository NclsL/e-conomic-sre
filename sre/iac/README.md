### Quickstart developer guide

#### Prerequisites
  - Install Terraform 1.9.2
  - Service Account in GCP with Editor role (TODO: Least privilege)
  - Create bucket in GCP for Terraform state
  - Enable GKE API
    - https://console.cloud.google.com/flows/enableapi?apiid=container.googleapis.com
  - Enable billing
    - `gcloud beta billing projects describe project-name`

#### Development
- `gcloud config set project`
- `gcloud auth application-default login`
- `terraform init`
- `terraform plan -input=false -var-file=./cicd.tfvars`
- `terraform apply -input=false -var-file=./cicd.tfvars`

But use CICD when possible

#### Deployment
- Commit to sre/iac folder master branch, GitHub Actions will deploy it
