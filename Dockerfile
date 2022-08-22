FROM fluent/fluentd:v1.15-debian-1
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
