FROM ruby:2.3.1-slim

RUN mkdir /page_crawler \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libpq-dev zlib1g-dev liblzma-dev netcat build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /page_crawler
ADD . /page_crawler
EXPOSE 3000

ENV RAILS_ENV=production

RUN gem install bundler && bundle install --without development test

CMD ["bash", "init.sh"]
