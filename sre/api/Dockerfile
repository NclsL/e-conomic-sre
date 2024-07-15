# TODO Set the hash
FROM python:3.12.4-slim-bookworm

WORKDIR /app

COPY requirements.txt .

# For python-magic
RUN apt-get update && apt-get install -y \
	libmagic-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install -r requirements.txt

COPY app/main.py .

RUN groupadd -g 13337 itsamemario \
	&& useradd --uid 13338 --gid itsamemario --shell /bin/bash --create-home itsamemario

USER itsamemario

CMD ["fastapi", "run"]
