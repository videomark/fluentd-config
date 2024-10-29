FROM fluent/fluentd:v1.17-debian-1@sha256:99e4bb4fae5fa19b162abb2a812d3eb5f16614509f948f86590bc858e37fc9fb
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
