FROM python:3.11-slim

ENV PYTHONUNBUFFERED 1

# Set the working directory
COPY . /app
WORKDIR /app

RUN mkdir /data
VOLUME "/data"

# Install matching chromedriver
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}') \
    && CHROME_MAJOR=$(echo $CHROME_VERSION | cut -d. -f1) \
    && DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR}") \
    && wget -q "https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip" \
    && unzip chromedriver_linux64.zip -d /usr/bin/ \
    && rm chromedriver_linux64.zip \
    && chmod +x /usr/bin/chromedriver

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

ENV IS_CONTAINERIZED=true

CMD ["python", "amazon-deals-telegram-bot"]