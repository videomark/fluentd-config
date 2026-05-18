FROM fluent/fluentd:v1.19-debian-1@sha256:f29b1d1103afd4bbcab8a17ecfefb411674ec57694f0cbd6641b4ae4dd65e13b
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
