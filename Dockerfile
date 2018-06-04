FROM ruby:latest

RUN apt-get update && apt-get install -y \
	cron \
	curl \
  libfontconfig \
  unzip \
  xvfb

RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

ENV CHROME_DRIVER_PATH /usr/local/bin/chromedriver


COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

RUN mkdir /app
WORKDIR /app
ADD . .

RUN bundle install

ADD crontab /etc/cron.d/mfp-login
RUN chmod +x /etc/cron.d/mfp-login /app/main.rb
RUN /usr/bin/crontab /etc/cron.d/mfp-login

CMD ["cron", "-f"]
