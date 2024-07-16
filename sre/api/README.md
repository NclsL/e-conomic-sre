### Quickstart developer guide

#### Prerequisites
Install (mini)conda

#### Development
`conda create --name sre-task python=3.12 pip`
`conda activate sre-task`
`pip install -r requirements.txt`
`fastapi dev ./app/main.py`

#### Dockerize
`docker build -f Dockerfile . -t image-name`
`docker run -p 8000:8000 image-name`

#### Test
`pip install pytest`
`pytest ./app`

### Deployment
- Commit to sre/api folder master branch
