FROM fluent/fluentd:v1.16-debian-1@sha256:c7bd75c6666fbccf92cfd2f0f3a0ec5236b7e79f2291e83bf336546a19e0cc6b
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
