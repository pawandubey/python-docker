FROM python:3.8.13-slim-buster AS development_build

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VERSION=1.1.14

RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    bash \
    curl \
    && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

ENV PATH="/root/.poetry/bin:$PATH"

WORKDIR /app

COPY ./poetry.lock ./pyproject.toml /app/

RUN poetry install --no-dev --no-interaction --no-ansi

ENTRYPOINT ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8765"]

EXPOSE 8765

FROM development_build AS production_build

COPY . /app
