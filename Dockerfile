FROM python:3.12.8-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10000 -ms /bin/bash runner

WORKDIR /home/runner/app

USER 10000

ENV PATH="${PATH}:/home/runner/.local/bin"

# Copiamos solo dependencias
COPY pyproject.toml poetry.lock ./

# Instalamos poetry sin virtualenv
RUN pip install --upgrade pip \
    && pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false \
    && poetry install --only main

# Copiamos el resto del proyecto
COPY . .

# Documentación
EXPOSE 8000

# Asegura que poetry NO cree virtualenvs
ENV POETRY_VIRTUALENVS_CREATE=false

ENTRYPOINT ["poetry", "run"]

# >>> ESTA LÍNEA VA AL FINAL <<<
CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT}
