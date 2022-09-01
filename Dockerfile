FROM fluent/fluentd:v1.15-debian-1@sha256:c8fe10334804974ffd32e860e2db015f5d3fb8822fe5e18fce894f55decc45eb
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
