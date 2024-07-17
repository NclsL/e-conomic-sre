### Quick info

I've developed an API microservice with Python, located in `./sre/api`.  
The `.github/workflows/` contains the CICD for publishing an image and infrastructure provisioning.  
Further in `./sre/iac` there are Terraform configurations and k8s manifests. The infrastructure setup is fairly minimal:
- GCP Bucket for TF state
- GCR/Artifact registry
- VPC, dual-stack IPV4/6 subnets
- k8s dual-stack autopiloted cluster
    - An ingress
    - A service
      - For API and dummy-microservice
    - Deployment
      - For API and dummy-microservice

Right now if you're reading this, the service probably isn't available publicly. I'll spin it up during interview or days prior to it. (At one point I might've forgotten another cluster running for over a month and as a result the GCP credits might have evaporated)

- Once deployed, it will be available via IP exposed by the ingress. The following endpoints are available:
- `/` will remind you to supply an integer in the URL
- `/[int]` will fetch the dummy pdf or png from the other microservice
- `/metrics` to expose some prometheus metrics

It took me about:
- 1.5hrs to develop the API microservice, Dockerfile, and github workflows to run and build the container
- 1.5hrs to setup Terraform, GCR and workflows to run terraform apply
- 1 hr to setup a basic autopiloted k8s cluster to GKE with hello-world application
- 1+ hr to create manifests for both of the applications
  - Had some ingress debugging to do which took some extra time
    - My api expecting number when calling `/` was an issue
  - Decided to go with a little overtime to get (almost) everything up and running!
    - The one thing missing: I did not have time to provision prometheus/grafana to the cluster. The API does publish some metrics, but prometheus isn't collecting it and grafana isn't there to draw pretty graphs.


I could still spend hours to improve this, but given the time limitation, I prioritized a service that is usable with fairly sensible CI/CD. There are number of things I would still improve upon, but those we shall discuss more during the interview.
