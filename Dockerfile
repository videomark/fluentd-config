FROM fluent/fluentd:v1.16-debian-1@sha256:1bb76b9efb929d1b79c18d9c5d8342fd64e89355e34d5ec189bb5637fbfdc901
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
