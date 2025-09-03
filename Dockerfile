FROM python:3.13-alpine

ENV PYTHONUNBUFFERED 1

# Set the working directory
COPY . /app
WORKDIR /app

RUN mkdir /data
VOLUME "/data"

RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

ENV IS_CONTAINERIZED=true

CMD ["python", "amazon-deals-telegram-bot"]