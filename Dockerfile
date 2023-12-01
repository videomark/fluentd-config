FROM fluent/fluentd:v1.16-debian-1@sha256:68b36d508307cc09182417d892d7878ed3ad7e9c177ea9833b552be46a610519
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  libgeoip-dev \
  libmaxminddb-dev \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /fluentd/etc
COPY ./fluent.conf ./Gemfile ./Gemfile.lock ./
RUN bundle install
USER fluent
