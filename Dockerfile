FROM fluent/fluentd:v1.16-debian-1@sha256:97dccd590a028e61cd786ef3e0189a9f41846133b2fb8ab9e62b61c385173035
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
