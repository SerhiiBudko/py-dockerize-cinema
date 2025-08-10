FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# системні пакети: клієнт Postgres для pg_isready, білд-інструменти, та Pillow deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    build-essential \
    libpq-dev \
    zlib1g-dev \
    libjpeg-dev \
 && rm -rf /var/lib/apt/lists/*

# залежності python
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# код
COPY . .

# статик/медіа директорії
RUN mkdir -p /vol/static /vol/media

# некореневий користувач (опційно, але краще)
RUN useradd -ms /bin/bash appuser
USER appuser

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
